import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/error/failures.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/usecases/auth/register_with_otp_usecase.dart';
import '../../../injection/injection_container.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_field.dart';
import '../../widgets/feature_icon.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _name = '';
  String _email = '';
  String _pw = '';
  bool _showPw = false;
  bool _agree = true;
  bool _loading = false;

  bool get _valid =>
      _name.length > 1 && _email.contains('@') && _pw.length >= 6 && _agree;

  Future<void> _register() async {
    setState(() => _loading = true);
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _pw,
      );
      await credential.user?.updateDisplayName(_name);

      final idToken = await credential.user?.getIdToken();
      if (idToken == null) throw Exception('Gagal mendapatkan token Firebase');

      await sl<RegisterWithOtpUsecase>()(idToken);

      if (mounted) context.go('/verify-email');
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.message ?? 'Registrasi gagal.'),
              backgroundColor: AppColors.error),
        );
      }
    } on ServerFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.error),
        );
      }
    } on NetworkFailure catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Tidak ada koneksi internet.'),
              backgroundColor: AppColors.error),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => context.go('/'),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppColors.shadowSoft,
                    ),
                    child: const Icon(DkgIcons.arrowLeft,
                        size: 18, color: AppColors.ink),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buat akun baru',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: -0.6,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Daftar gratis dalam 1 menit',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.slate500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    AppField(
                      label: 'Nama lengkap',
                      value: _name,
                      onChanged: (v) => setState(() => _name = v),
                      placeholder: 'Nama Lengkap',
                      prefixIcon: const Icon(DkgIcons.user, size: 20),
                    ),
                    const SizedBox(height: 14),
                    AppField(
                      label: 'Email',
                      value: _email,
                      onChanged: (v) => setState(() => _email = v),
                      placeholder: 'nama@email.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(DkgIcons.mail, size: 20),
                    ),
                    const SizedBox(height: 14),
                    AppField(
                      label: 'Kata sandi',
                      value: _pw,
                      onChanged: (v) => setState(() => _pw = v),
                      obscureText: !_showPw,
                      placeholder: 'Min. 6 karakter',
                      prefixIcon: const Icon(DkgIcons.lock, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                            _showPw ? DkgIcons.eyeOff : DkgIcons.eye,
                            size: 20,
                            color: AppColors.slate400),
                        onPressed: () => setState(() => _showPw = !_showPw),
                      ),
                    ),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: () => setState(() => _agree = !_agree),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              gradient: _agree ? AppColors.primaryGradient : null,
                              color: _agree ? null : Colors.white,
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: _agree ? Colors.transparent : AppColors.line,
                                width: 1.5,
                              ),
                              boxShadow: _agree
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  : [],
                            ),
                            child: _agree
                                ? const Icon(DkgIcons.check,
                                    size: 14, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.slate500,
                                  height: 1.5,
                                ),
                                children: [
                                  const TextSpan(text: 'Saya setuju dengan '),
                                  TextSpan(
                                    text: 'Syarat & Ketentuan',
                                    style: GoogleFonts.inter(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: ' dan '),
                                  TextSpan(
                                    text: 'Kebijakan Privasi',
                                    style: GoogleFonts.inter(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    AppButton(
                      label: 'Buat Akun',
                      onPressed: _valid ? _register : null,
                      isLoading: _loading,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah punya akun? ',
                          style: GoogleFonts.inter(
                              fontSize: 14, color: AppColors.slate500),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: Text(
                            'Masuk',
                            style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
