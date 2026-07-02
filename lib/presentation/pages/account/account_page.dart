import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/app_badge.dart';
import '../../widgets/feature_icon.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/');
        }
      },
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // ─── Profile Header ───────────────────────────────
                Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.walletGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).padding.top + 12, 20, 28),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        right: -20,
                        top: -20,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          AppAvatar(
                              name: user?.name ?? 'User',
                              size: 62),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.name ?? 'Pengguna',
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  user?.email ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.65),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: AppColors.success
                                            .withValues(alpha: 0.4),
                                        width: 1),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.verified_user_rounded,
                                          size: 12, color: Colors.white),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Terverifikasi',
                                        style: GoogleFonts.inter(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── Security Section ──────────────────────────
                      _SectionTitle('Keamanan'),
                      const SizedBox(height: 8),
                      _MenuCard(children: [
                        _Row(
                          icon: Icons.verified_user_rounded,
                          tone: 'green',
                          title: 'Verifikasi 2 langkah (2FA)',
                          subtitle: 'Aktif · Email OTP',
                          onTap: () => context.go('/setup-2fa'),
                          right: const AppBadge(label: 'Aktif', tone: 'green'),
                        ),
                        _Divider(),
                        _Row(
                          icon: Icons.lock_rounded,
                          tone: 'blue',
                          title: 'Ubah PIN keamanan',
                          subtitle: 'Terakhir diubah 2 bln lalu',
                          onTap: () {},
                        ),
                        _Divider(),
                        _Row(
                          icon: Icons.fingerprint_rounded,
                          tone: 'purple',
                          title: 'Login biometrik',
                          subtitle: 'Sidik jari',
                          onTap: () {},
                          right: _Toggle(),
                        ),
                      ]),

                      const SizedBox(height: 20),

                      // ─── Account Section ───────────────────────────
                      _SectionTitle('Akun'),
                      const SizedBox(height: 8),
                      _MenuCard(children: [
                        _Row(
                          icon: Icons.person_rounded,
                          tone: 'blue',
                          title: 'Data pribadi',
                          onTap: () {},
                        ),
                        _Divider(),
                        _Row(
                          icon: Icons.account_balance_rounded,
                          tone: 'green',
                          title: 'Rekening & kartu tersimpan',
                          onTap: () {},
                        ),
                        _Divider(),
                        _Row(
                          icon: Icons.settings_rounded,
                          tone: 'slate',
                          title: 'Pengaturan aplikasi',
                          onTap: () {},
                        ),
                      ]),

                      const SizedBox(height: 20),

                      // ─── Logout ────────────────────────────────────
                      GestureDetector(
                        onTap: () =>
                            context.read<AuthBloc>().add(AuthLogoutRequested()),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: AppColors.shadowSoft,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.logout_rounded,
                                  size: 20, color: AppColors.error),
                              const SizedBox(width: 10),
                              Text(
                                'Keluar',
                                style: GoogleFonts.inter(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'TechPay · v1.0.0',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.slate300,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.slate400,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<Widget> children;
  const _MenuCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.shadowCard,
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 70, color: AppColors.line2);
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String tone;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? right;

  const _Row({
    required this.icon,
    required this.tone,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            FeatureIcon(icon: icon, tone: tone, size: 42, iconSize: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.slate400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            right ??
                const Icon(Icons.chevron_right_rounded,
                    size: 18, color: AppColors.slate300),
          ],
        ),
      ),
    );
  }
}

class _Toggle extends StatefulWidget {
  @override
  State<_Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<_Toggle> {
  bool _on = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _on = !_on),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 46,
        height: 26,
        decoration: BoxDecoration(
          gradient: _on ? AppColors.primaryGradient : null,
          color: _on ? null : AppColors.line,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: _on ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
