import 'package:flutter/material.dart';
import '../data/portal_data.dart';
import '../theme/app_theme.dart';
import '../widgets/ui.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key, required this.completed, required this.onToggle});
  final Set<int> completed;
  final void Function(int index, bool value) onToggle;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 27, 20, 35),
    children: [
      const GothicHeading(kicker: 'Таємна лабораторія', title: 'Ритуали виживання', subtitle: 'Знання вічні, але очам і спині потрібен перепочинок.'),
      const SizedBox(height: 22),
      GothicCard(background: Palette.raised, child: Row(children: [
        const GothicSymbol(Icons.local_fire_department_rounded, size: 55, color: Palette.bright),
        const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Свічки цього дня', style: TextStyle(color: Palette.gold, fontSize: 13)),
          const SizedBox(height: 4),
          Text('${completed.length} із ${habits.length} запалено', style: const TextStyle(fontSize: 19, color: Palette.parchment, fontWeight: FontWeight.w700)),
        ])),
      ])),
      const SizedBox(height: 19),
      const GothicSection('Щоденні обряди'),
      const SizedBox(height: 14),
      ...List.generate(habits.length, (i) {
        final habit = habits[i];
        final done = completed.contains(i);
        return Padding(
          padding: const EdgeInsets.only(bottom: 11),
          child: GothicCard(
            onTap: () => onToggle(i, !done),
            child: Row(children: [
              Icon(done ? Icons.local_fire_department : Icons.local_fire_department_outlined, color: done ? Palette.gold : Palette.muted, size: 33),
              const SizedBox(width: 13),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(habit.title, style: const TextStyle(fontSize: 15, color: Palette.parchment, fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                Text(habit.subtitle, style: const TextStyle(fontSize: 11, color: Palette.muted, fontFamily: 'Roboto', height: 1.4)),
              ])),
              Checkbox(value: done, onChanged: (v) => onToggle(i, v ?? false)),
            ]),
          ),
        );
      }),
      const SizedBox(height: 16),
      const GothicSection('Поради з давнього манускрипту'),
      const SizedBox(height: 14),
      const _Advice(Icons.visibility_outlined, 'Чари для очей', 'Кожні 20 хвилин дивись у далечінь приблизно на 6 метрів упродовж 20 секунд.'),
      const SizedBox(height: 11),
      const _Advice(Icons.accessibility_new, 'Повстань із трону', 'Час від часу вставай, походи кімнатою та обережно розімни плечі.'),
      const SizedBox(height: 11),
      const _Advice(Icons.chair_outlined, 'Зручний трон', 'Підтримуй спину, не нахиляй шию до екрана та змінюй позу.'),
      const SizedBox(height: 23),
      const GothicSection('Три вправи після опівночі'),
      const SizedBox(height: 14),
      const GothicCard(child: Column(children: [
        _Exercise('I', 'Плечі', 'Повільно зроби кілька кругових рухів.'),
        Divider(height: 24),
        _Exercise('II', 'Шия', 'Обережно нахили голову праворуч і ліворуч.'),
        Divider(height: 24),
        _Exercise('III', 'Кисті', 'Розімни пальці та зап’ястя.'),
      ])),
      const SizedBox(height: 17),
      const Text('Список ритуалів оновлюється щодня. Відмітки зберігаються на пристрої.', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto', fontSize: 11, color: Palette.muted)),
    ],
  );
}

class _Advice extends StatelessWidget {
  const _Advice(this.icon, this.title, this.detail);
  final IconData icon;
  final String title, detail;
  @override
  Widget build(BuildContext context) => GothicCard(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    GothicSymbol(icon, size: 43), const SizedBox(width: 13),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Palette.parchment)),
      const SizedBox(height: 7),
      Text(detail, style: const TextStyle(fontSize: 12, height: 1.55, color: Palette.muted, fontFamily: 'Roboto')),
    ])),
  ]));
}

class _Exercise extends StatelessWidget {
  const _Exercise(this.number, this.title, this.detail);
  final String number, title, detail;
  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    SizedBox(width: 31, child: Text(number, style: const TextStyle(color: Palette.gold, fontSize: 21, fontWeight: FontWeight.w700))),
    const SizedBox(width: 9),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Palette.parchment)),
      const SizedBox(height: 5),
      Text(detail, style: const TextStyle(fontFamily: 'Roboto', fontSize: 12, color: Palette.muted)),
    ])),
  ]);
}
