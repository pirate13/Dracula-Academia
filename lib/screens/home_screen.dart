import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onNavigate, required this.completedTasks, required this.totalTasks});
  final ValueChanged<int> onNavigate;
  final int completedTasks;
  final int totalTasks;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 27, 20, 35),
    children: [
      const Text('✦  DRACULA ACADEMIA  ✦', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto', fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 3, color: Palette.gold)),
      const SizedBox(height: 19),
      const GothicHeading(kicker: 'Ваша темна величносте', title: 'Ласкаво просимо\nдо замку знань', subtitle: 'Навіть безсмертним доводиться здавати практичні роботи.'),
      const SizedBox(height: 18),
      GothicCard(
        padding: EdgeInsets.zero,
        background: const Color(0xFF292234),
        child: Column(children: [
          const CastleIllustration(),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 3, 18, 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Хроніки цього семестру', style: TextStyle(fontSize: 19, color: Palette.parchment, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Text('$completedTasks із $totalTasks випробувань пройдено', style: const TextStyle(fontSize: 12, color: Palette.muted, fontFamily: 'Roboto')),
              const SizedBox(height: 12),
              ClipRRect(borderRadius: BorderRadius.circular(7), child: LinearProgressIndicator(value: totalTasks == 0 ? 0 : completedTasks / totalTasks, minHeight: 8, color: Palette.bright, backgroundColor: Palette.background)),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 27),
      const GothicSection('Оберіть двері'),
      const SizedBox(height: 15),
      _DoorCard(icon: Icons.menu_book_outlined, number: 'I', title: 'Книга проклять', subtitle: 'Завдання та дедлайни', onTap: () => onNavigate(1)),
      const SizedBox(height: 11),
      _DoorCard(icon: Icons.badge_outlined, number: 'II', title: 'Паспорт безсмертного', subtitle: 'Цифрова картка студента', onTap: () => onNavigate(2)),
      const SizedBox(height: 11),
      _DoorCard(icon: Icons.local_fire_department_outlined, number: 'III', title: 'Ритуали виживання', subtitle: 'Здоров’я, фокус та звички', onTap: () => onNavigate(3)),
      const SizedBox(height: 22),
      const Center(child: Text('☾   KNOWLEDGE NEVER DIES   ☽', style: TextStyle(fontFamily: 'Roboto', fontSize: 10, color: Palette.gold, letterSpacing: 2))),
    ],
  );
}

class _DoorCard extends StatelessWidget {
  const _DoorCard({required this.icon, required this.number, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String number, title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GothicCard(
    onTap: onTap,
    child: Row(children: [
      GothicSymbol(icon, size: 54),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$number  •  $title', style: const TextStyle(fontSize: 16, color: Palette.parchment, fontWeight: FontWeight.w700)),
        const SizedBox(height: 5),
        Text(subtitle, style: const TextStyle(fontSize: 12, fontFamily: 'Roboto', color: Palette.muted)),
      ])),
      const Icon(Icons.chevron_right, color: Palette.gold),
    ]),
  );
}
