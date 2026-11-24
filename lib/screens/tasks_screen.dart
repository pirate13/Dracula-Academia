import 'package:flutter/material.dart';
import '../models/study_task.dart';
import '../services/task_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/ui.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  static String _date(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  Future<void> _handle(BuildContext context, Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка збереження: $e')));
      }
    }
  }

  Future<void> _delete(BuildContext context, StudyTask task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Видалити завдання?'),
        content: Text(task.title),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Скасувати')),
          TextButton(onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Видалити')),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await _handle(context, () => TaskRepository.instance.deleteTask(task));
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<StudyTask>>(
    stream: TaskRepository.instance.watchTasks(),
    builder: (context, snapshot) {
      final tasks = snapshot.data ?? [];
      final doneCount = tasks.where((t) => t.completed).length;
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 27, 20, 35),
        children: [
          const GothicHeading(kicker: 'Архів темних справ', title: 'Книга проклять',
            subtitle: 'Завдання зберігаються у Firestore. Закрий труну, коли справу виконано.'),
          const SizedBox(height: 20),
          GothicCard(background: Palette.raised, child: Row(children: [
            const CoffinIcon(closed: true, size: 31),
            const SizedBox(width: 17),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('$doneCount / ${tasks.length}', style: const TextStyle(
                color: Palette.parchment, fontSize: 27, fontWeight: FontWeight.w700)),
              const Text('проклять знято', style: TextStyle(
                color: Palette.muted, fontFamily: 'Roboto', fontSize: 12)),
            ])),
            const Icon(Icons.nightlight_round, color: Palette.gold, size: 30),
          ])),
          const SizedBox(height: 15),
          FilledButton.icon(
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const TaskEditor())),
            icon: const Icon(Icons.add), label: const Text('Додати завдання')),
          const SizedBox(height: 24),
          const GothicSection('Записи в гримуарі'),
          const SizedBox(height: 14),
          if (snapshot.hasError)
            Text('Не вдалося завантажити завдання: ${snapshot.error}',
              style: const TextStyle(color: Palette.parchment))
          else if (snapshot.connectionState == ConnectionState.waiting)
            const Center(child: CircularProgressIndicator())
          else if (tasks.isEmpty)
            const GothicCard(child: Text('Завдань поки немає. Додай перше.',
              style: TextStyle(color: Palette.parchment)))
          else
            ...tasks.map((task) => Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: GothicCard(
                background: task.completed ? const Color(0xFF29202C) : Palette.panel,
                child: Row(children: [
                  CoffinIcon(closed: task.completed, size: 38),
                  const SizedBox(width: 13),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(task.title, style: TextStyle(
                      color: Palette.parchment, fontSize: 17, fontWeight: FontWeight.w700,
                      decoration: task.completed ? TextDecoration.lineThrough : null)),
                    const SizedBox(height: 6),
                    Text(task.description, style: const TextStyle(color: Palette.muted,
                      fontFamily: 'Roboto', fontSize: 12)),
                    const SizedBox(height: 8),
                    Text('${_date(task.deadline)}  •  ${task.completed ? 'Труну закрито' : 'Очікує'}',
                      style: const TextStyle(color: Palette.gold, fontFamily: 'Roboto', fontSize: 11)),
                    Row(children: [
                      IconButton(tooltip: 'Редагувати', icon: const Icon(Icons.edit_outlined, size: 19),
                        onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => TaskEditor(task: task)))),
                      IconButton(tooltip: 'Видалити', icon: const Icon(Icons.delete_outline, size: 19),
                        onPressed: () => _delete(context, task)),
                    ]),
                  ])),
                  Checkbox(value: task.completed,
                    onChanged: (value) => _handle(context,
                      () => TaskRepository.instance.setCompleted(task, value ?? false))),
                ]),
              ),
            )),
        ],
      );
    },
  );
}

class TaskEditor extends StatefulWidget {
  const TaskEditor({super.key, this.task});
  final StudyTask? task;
  @override
  State<TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late DateTime _deadline;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.task?.title ?? '');
    _description = TextEditingController(text: widget.task?.description ?? '');
    _deadline = widget.task?.deadline ?? DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate() || _saving) return;
    setState(() => _saving = true);
    try {
      final repo = TaskRepository.instance;
      if (widget.task == null) {
        await repo.addTask(_title.text.trim(), _description.text.trim(), _deadline);
      } else {
        await repo.updateTask(widget.task!, _title.text.trim(),
          _description.text.trim(), _deadline);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка збереження: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.task == null ? 'Нове завдання' : 'Редагувати завдання')),
    body: SafeArea(child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(key: _form, child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TextFormField(controller: _title, maxLength: 120,
            decoration: const InputDecoration(labelText: 'Назва завдання'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Введіть назву' : null),
          const SizedBox(height: 12),
          TextFormField(controller: _description, maxLines: 3, maxLength: 500,
            decoration: const InputDecoration(labelText: 'Короткий опис')),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.event),
            label: Text('Дедлайн: ${TasksScreen._date(_deadline)}'),
            onPressed: () async {
              final chosen = await showDatePicker(context: context,
                initialDate: _deadline,
                firstDate: DateTime(2020), lastDate: DateTime(2100));
              if (chosen != null) setState(() => _deadline = chosen);
            },
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Збереження...' : 'Зберегти')),
        ],
      )),
    )),
  );
}
