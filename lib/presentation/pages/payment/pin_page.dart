import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/deeplink_callback_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/datasources/local/secure_storage_datasource.dart';
import '../../../injection/injection_container.dart';
import '../../blocs/auth/otp_bloc.dart';
import '../../blocs/payment/payment_bloc.dart';
import '../../widgets/code_input.dart';
import '../../widgets/feature_icon.dart';
import '../../widgets/pin_pad.dart';

enum _Step { pin, otp }

class PinPage extends StatefulWidget {
  final Map<String, dynamic> flowData;
  const PinPage({super.key, required this.flowData});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  _Step _step = _Step.pin;
  String _pin = '';
  String _otpCode = '';
  bool _busy = false;
  bool _otpError = false;

  String _twoFaMethod = AppConstants.twoFaTotp;

  int _resendTimer = AppConstants.otpResendSeconds;
  Timer? _countdown;

  @override
  void dispose() {
    _countdown?.cancel();
    super.dispose();
  }

  void _onPinComplete(String pin) {
    setState(() {
      _pin = pin;
      _busy = true;
    });

    final kind = widget.flowData['kind'] as String? ?? '';
    if (kind == AppConstants.txnTopup) {
      context.read<PaymentBloc>().add(PaymentTopupRequested(
        (widget.flowData['amount'] as num).toDouble(),
      ));
    } else {
      _prepareOtpStep();
    }
  }

  Future<void> _prepareOtpStep() async {
    final method = await sl<SecureStorageDatasource>().get2faMethod();
    if (!mounted) return;

    setState(() {
      _twoFaMethod = method ?? AppConstants.twoFaTotp;
      _busy = false;
      _step = _Step.otp;
    });

    if (_twoFaMethod == AppConstants.twoFaSmtp) {
      context.read<OtpBloc>().add(OtpSendEmail());
      _startResendTimer();
    } else if (_twoFaMethod == AppConstants.twoFaNotif) {
      context.read<OtpBloc>().add(OtpSendFirebase());
      _startResendTimer();
    }
  }

  void _startResendTimer() {
    _countdown?.cancel();
    setState(() => _resendTimer = AppConstants.otpResendSeconds);
    _countdown = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendTimer <= 0) {
        t.cancel();
      } else {
        setState(() => _resendTimer--);
      }
    });
  }

  void _resendOtp() {
    if (_twoFaMethod == AppConstants.twoFaSmtp) {
      context.read<OtpBloc>().add(OtpSendEmail());
    } else if (_twoFaMethod == AppConstants.twoFaNotif) {
      context.read<OtpBloc>().add(OtpSendFirebase());
    }
    _startResendTimer();
  }

  String get _otpType {
    switch (_twoFaMethod) {
      case AppConstants.twoFaSmtp:
        return AppConstants.otpTypeEmail;
      case AppConstants.twoFaNotif:
        return AppConstants.otpTypeFirebase;
      default:
        return AppConstants.otpTypeTotp;
    }
  }

  String _descriptionFor(Map<String, dynamic> flow) {
    final kind = flow['kind'] as String? ?? '';
    if (kind == AppConstants.txnTransfer) {
      return flow['note'] as String? ?? 'Transfer';
    }
    return flow['description'] as String? ?? 'Pembayaran';
  }

  String? get _callbackUrl {
    final kind = widget.flowData['kind'] as String? ?? '';
    if (kind != 'deeplink') return null;
    final url = widget.flowData['callbackUrl'] as String?;
    return (url != null && url.isNotEmpty) ? url : null;
  }

  String? get _callbackReference => widget.flowData['reference'] as String?;

  void _onOtpChanged(String v) {
    setState(() {
      _otpCode = v;
      _otpError = false;
    });
    if (v.length == AppConstants.otpLength) {
      _submitPayment(v);
    }
  }

  void _submitPayment(String code) {
    setState(() => _busy = true);
    final flow = widget.flowData;
    context.read<PaymentBloc>().add(PaymentTransferRequested(
      amount: (flow['amount'] as num).toDouble(),
      description: _descriptionFor(flow),
      otpCode: code,
      otpType: _otpType,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentTransferSuccess) {
              final result = state.result;
              final cb = _callbackUrl;
              if (cb != null) {
                DeeplinkCallbackService.notifySuccess(
                  callbackUrl: cb,
                  reference: _callbackReference,
                  transactionId: result.transactionId,
                );
              }
              context.go('/success', extra: {
                'title': 'Pembayaran berhasil',
                'subtitle': result.description,
                'amount': result.amount,
                'lines': [
                  ['Jumlah', CurrencyFormatter.format(result.amount)],
                  ['Saldo setelah', CurrencyFormatter.format(result.balanceAfter)],
                  ['Ref', 'TKP${result.transactionId}'],
                ],
              });
            } else if (state is PaymentTopupSuccess) {
              context.go('/success', extra: {
                'title': 'Top up berhasil',
                'subtitle': 'Saldo kamu bertambah',
                'amount': state.amount,
                'lines': [
                  ['Jumlah', CurrencyFormatter.format(state.amount)],
                  ['Saldo sekarang', CurrencyFormatter.format(state.balance)],
                ],
              });
            } else if (state is PaymentInvalidOtp) {
              setState(() {
                _busy = false;
                _otpError = true;
                _otpCode = '';
              });
              Future.delayed(const Duration(milliseconds: 800), () {
                if (mounted) setState(() => _otpError = false);
              });
            } else if (state is PaymentInsufficientBalance) {
              setState(() => _busy = false);
              final cb = _callbackUrl;
              if (cb != null) {
                DeeplinkCallbackService.notifyFailed(
                  callbackUrl: cb,
                  reference: _callbackReference,
                  errorMessage: 'insufficient_balance',
                );
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Saldo tidak cukup. Saldo kamu saat ini ${CurrencyFormatter.format(state.balance)}.'),
                  backgroundColor: AppColors.error,
                ),
              );
            } else if (state is PaymentError) {
              setState(() => _busy = false);
              final cb = _callbackUrl;
              if (cb != null) {
                DeeplinkCallbackService.notifyFailed(
                  callbackUrl: cb,
                  reference: _callbackReference,
                  errorMessage: 'payment_error',
                );
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error),
              );
            }
          },
        ),
        BlocListener<OtpBloc, OtpState>(
          listener: (context, state) {
            if (state is OtpError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Close / back row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      if (_step == _Step.otp && !_busy) {
                        _countdown?.cancel();
                        setState(() {
                          _step = _Step.pin;
                          _pin = '';
                          _otpCode = '';
                        });
                      } else {
                        final cb = _callbackUrl;
                        if (cb != null) {
                          DeeplinkCallbackService.notifyCancelled(
                            callbackUrl: cb,
                            reference: _callbackReference,
                          );
                        }
                        context.go('/home');
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: AppColors.slate600, size: 20),
                    ),
                  ),
                ),
              ),

              // Step indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Row(
                  children: [
                    _StepDot(active: true, done: _step == _Step.otp),
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          gradient: _step == _Step.otp
                              ? AppColors.primaryGradient
                              : null,
                          color: _step == _Step.otp ? null : AppColors.line2,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                    _StepDot(active: _step == _Step.otp),
                  ],
                ),
              ),

              if (_busy) ...[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 42,
                        height: 42,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor:
                              AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Memproses transaksi…',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate600,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (_step == _Step.pin) ...[
                Expanded(child: _buildPinStep()),
              ] else ...[
                Expanded(child: _buildOtpStep()),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinStep() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(18),
              boxShadow: AppColors.shadowPrimary,
            ),
            child: const Center(
                child: Icon(Icons.lock_rounded, size: 26, color: Colors.white)),
          ),
          const SizedBox(height: 16),
          Text(
            'Masukkan PIN',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Masukkan 6 digit PIN keamanan kamu',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: AppColors.slate500,
            ),
          ),
          const Spacer(),
          PinPad(
            value: _pin,
            onChanged: (v) => setState(() => _pin = v),
            onComplete: _onPinComplete,
          ),
          const SizedBox(height: 16),
          Text.rich(TextSpan(
            text: 'Lupa PIN? ',
            style: GoogleFonts.inter(
                fontSize: 12.5, color: AppColors.slate400),
            children: [
              TextSpan(
                text: 'Reset',
                style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildOtpStep() {
    final header = _otpHeader;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          FeatureIcon(
              icon: header.icon, tone: header.tone, size: 72, iconSize: 36),
          const SizedBox(height: 18),
          Text(
            header.title,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            header.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14.5,
              color: AppColors.slate500,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 28),
          AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            transform: _otpError
                ? (Matrix4.identity()..translateByDouble(8.0, 0, 0, 1))
                : Matrix4.identity(),
            child: CodeInput(
                value: _otpCode,
                onChanged: _onOtpChanged,
                hasError: _otpError),
          ),
          if (_otpError) ...[
            const SizedBox(height: 12),
            Text(
              'Kode OTP salah, silakan coba lagi',
              style: GoogleFonts.inter(
                color: AppColors.error,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 18),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primarySurface, AppColors.secondarySurface],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.primaryBorder.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                const Icon(DkgIcons.shieldCheck,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Total pembayaran ${CurrencyFormatter.format((widget.flowData['amount'] as num).toDouble())}',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (_twoFaMethod != AppConstants.twoFaTotp) ...[
            _resendTimer > 0
                ? Text(
                    'Kirim ulang dalam 00:${_resendTimer.toString().padLeft(2, '0')}',
                    style: GoogleFonts.inter(
                        fontSize: 13.5, color: AppColors.slate400),
                  )
                : TextButton.icon(
                    onPressed: _resendOtp,
                    icon: const Icon(DkgIcons.refresh,
                        size: 16, color: AppColors.primary),
                    label: Text(
                      'Kirim ulang kode',
                      style: GoogleFonts.inter(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
          ],
        ],
      ),
    );
  }

  ({IconData icon, String tone, String title, String subtitle})
      get _otpHeader {
    switch (_twoFaMethod) {
      case AppConstants.twoFaSmtp:
        return (
          icon: DkgIcons.mail,
          tone: 'blue',
          title: 'Masukkan Kode OTP Email',
          subtitle:
              'Kode 6 digit dikirim ke email kamu via SMTP untuk konfirmasi pembayaran.',
        );
      case AppConstants.twoFaNotif:
        return (
          icon: Icons.notifications_rounded,
          tone: 'green',
          title: 'Masukkan Kode OTP',
          subtitle:
              'Kami mengirim kode verifikasi ke notifikasi perangkat kamu.',
        );
      default:
        return (
          icon: DkgIcons.smartphone,
          tone: 'purple',
          title: 'Masukkan Kode Authenticator',
          subtitle:
              'Buka aplikasi authenticator kamu dan masukkan kode yang sedang aktif.',
        );
    }
  }
}

class _StepDot extends StatelessWidget {
  final bool active;
  final bool done;
  const _StepDot({required this.active, this.done = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        gradient: active ? AppColors.primaryGradient : null,
        color: active ? null : AppColors.line2,
        shape: BoxShape.circle,
      ),
      child: done
          ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
          : Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active
                      ? Colors.white
                      : AppColors.slate300,
                ),
              ),
            ),
    );
  }
}
