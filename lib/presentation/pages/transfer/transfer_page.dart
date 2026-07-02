import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/app_field.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/feature_icon.dart';

const _contacts = [
  {'id': '1', 'name': 'Budi Santoso', 'sub': '0812-3456-7890', 'fav': true},
  {'id': '2', 'name': 'Citra Dewi', 'sub': '0856-1122-3344', 'fav': true},
  {'id': '3', 'name': 'Eko Prasetyo', 'sub': '0813-9988-7766', 'fav': false},
  {'id': '4', 'name': 'Fitri Handayani', 'sub': '0821-4455-6677', 'fav': false},
  {'id': '5', 'name': 'Gilang Ramadhan', 'sub': '0857-3344-1122', 'fav': false},
];

const _banks = [
  {'id': 'bca', 'name': 'BCA', 'sub': 'Bank Central Asia', 'tone': 'blue'},
  {'id': 'bni', 'name': 'BNI', 'sub': 'Bank Negara Indonesia', 'tone': 'amber'},
  {'id': 'mandiri', 'name': 'Mandiri', 'sub': 'Bank Mandiri', 'tone': 'blue'},
  {'id': 'bri', 'name': 'BRI', 'sub': 'Bank Rakyat Indonesia', 'tone': 'green'},
];

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});
  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  String _tab = 'dkg';
  String _q = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar:
          AppTopBar(title: 'Transfer', onBack: () => context.go('/home')),
      body: Column(
        children: [
          // ─── Tab selector + Search ─────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Column(
              children: [
                // Tab pills
                Row(
                  children: [
                    ['dkg', 'Sesama TechPay'],
                    ['bank', 'Ke Bank']
                  ].map((t) {
                    final active = _tab == t[0];
                    return Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() { _tab = t[0]; _q = ''; }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            gradient: active ? AppColors.primaryGradient : null,
                            color: active ? null : AppColors.bg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              t[1],
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: active
                                    ? Colors.white
                                    : AppColors.slate500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                AppField(
                  value: _q,
                  onChanged: (v) => setState(() => _q = v),
                  placeholder: _tab == 'dkg'
                      ? 'Cari nama / nomor HP'
                      : 'Cari bank',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: AppColors.line2),
              ],
            ),
          ),

          // ─── List ────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _tab == 'dkg'
                  ? _buildContactList()
                  : _buildBankList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildContactList() {
    final favs = _contacts
        .where((c) => c['fav'] == true && _matches(c['name'] as String))
        .toList();
    final others = _contacts
        .where((c) => c['fav'] == false && _matches(c['name'] as String))
        .toList();

    return [
      if (favs.isNotEmpty) ...[
        _ListLabel('Favorit'),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppColors.shadowCard,
          ),
          child: Column(
            children: favs.asMap().entries.map((e) {
              return _ContactTile(
                contact: e.value,
                divider: e.key > 0,
                onTap: () => context.go('/transfer/amount', extra: e.value),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
      if (others.isNotEmpty) ...[
        _ListLabel('Kontak lain'),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppColors.shadowCard,
          ),
          child: Column(
            children: others.asMap().entries.map((e) {
              return _ContactTile(
                contact: e.value,
                divider: e.key > 0,
                onTap: () => context.go('/transfer/amount', extra: e.value),
              );
            }).toList(),
          ),
        ),
      ],
    ];
  }

  List<Widget> _buildBankList() {
    final filtered =
        _banks.where((b) => _matches(b['name'] as String)).toList();
    return [
      _ListLabel('Pilih bank tujuan'),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.shadowCard,
        ),
        child: Column(
          children: filtered.asMap().entries.map((e) {
            final b = e.value;
            return Column(
              children: [
                if (e.key > 0)
                  const Divider(
                      height: 1, indent: 70, color: AppColors.line2),
                GestureDetector(
                  onTap: () =>
                      context.go('/transfer/amount', extra: e.value),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        FeatureIcon(
                          icon: Icons.account_balance_rounded,
                          tone: b['tone'] as String,
                          size: 44,
                          iconSize: 22,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                b['name'] as String,
                                style: GoogleFonts.inter(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                              Text(
                                b['sub'] as String,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.slate400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded,
                            size: 18, color: AppColors.slate300),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    ];
  }

  bool _matches(String name) =>
      _q.isEmpty || name.toLowerCase().contains(_q.toLowerCase());
}

class _ListLabel extends StatelessWidget {
  final String text;
  const _ListLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 10),
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

class _ContactTile extends StatelessWidget {
  final Map<String, Object> contact;
  final bool divider;
  final VoidCallback onTap;

  const _ContactTile({
    required this.contact,
    required this.divider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (divider)
          const Divider(height: 1, indent: 70, color: AppColors.line2),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                AppAvatar(name: contact['name'] as String, size: 44),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact['name'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        contact['sub'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.slate400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (contact['fav'] == true)
                  const Icon(Icons.star_rounded,
                      size: 16, color: AppColors.warning),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded,
                    size: 18, color: AppColors.slate300),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
