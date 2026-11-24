import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/student_profile.dart';
import '../services/profile_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/ui.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ProfileRepository.instance;
    final user = repository.currentUser;
    if (user == null) return const Center(child: Text('Увійдіть до акаунта'));
    return StreamBuilder<StudentProfile?>(
      stream: repository.watchProfile(user.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) return _Message('Не вдалося завантажити профіль: ${snapshot.error}');
        if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final profile = snapshot.data ?? StudentProfile(
          fullName: '', group: '', specialty: '', email: user.email ?? '',
          studentId: '', about: '', university: '',
        );
        return ListView(padding: const EdgeInsets.fromLTRB(20, 27, 20, 35), children: [
          const GothicHeading(kicker: 'Королівський реєстр', title: 'Паспорт безсмертного',
            subtitle: 'Профіль із хмарного сховища Firebase'),
          const SizedBox(height: 18),
          Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(
            border: Border.all(color: Palette.gold, width: 1.4), borderRadius: BorderRadius.circular(20)),
            child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(
              color: Palette.parchment, borderRadius: BorderRadius.circular(14)),
              child: Column(children: [
                const Text('✠   ACADEMIA NOCTURNA   ✠',
                  style: TextStyle(color: Color(0xFF694B49), fontWeight: FontWeight.w700)),
                const SizedBox(height: 14),
                ClipOval(child: profile.photoUrl.isEmpty
                  ? Image.asset('assets/images/student_photo.png', width: 110, height: 110, fit: BoxFit.cover)
                  : Image.network(profile.photoUrl, width: 110, height: 110, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(width: 110, height: 110,
                      child: Icon(Icons.person, size: 60, color: Colors.brown)))),
                const SizedBox(height: 12),
                Text(profile.fullName.isEmpty ? 'Ім’я та прізвище' : profile.fullName,
                  style: const TextStyle(fontSize: 22, color: Color(0xFF412B31), fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _PaperLine('Заклад', profile.university),
                _PaperLine('Група', profile.group),
                _PaperLine('Номер квитка', profile.studentId),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          const GothicSection('Особова справа'),
          const SizedBox(height: 12),
          GothicCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _InfoLine('Спеціальність', profile.specialty),
            const Divider(),
            _InfoLine('Email', profile.email),
            const Divider(),
            _InfoLine('Про мене', profile.about),
          ])),
          const SizedBox(height: 16),
          FilledButton.icon(icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => EditProfileScreen(uid: user.uid, initial: profile))),
            label: const Text('Редагувати профіль і фото')),
          TextButton.icon(onPressed: () => repository.signOut(),
            icon: const Icon(Icons.logout), label: const Text('Вийти з акаунта')),
        ]);
      },
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.uid, required this.initial});
  final String uid;
  final StudentProfile initial;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _form = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _fields;
  Uint8List? _newPhoto;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _fields = {
      'fullName': TextEditingController(text: p.fullName),
      'group': TextEditingController(text: p.group),
      'specialty': TextEditingController(text: p.specialty),
      'email': TextEditingController(text: p.email),
      'studentId': TextEditingController(text: p.studentId),
      'about': TextEditingController(text: p.about),
      'university': TextEditingController(text: p.university),
    };
  }

  @override
  void dispose() { for (final c in _fields.values) { c.dispose(); } super.dispose(); }

  Future<void> _choosePhoto() async {
    final chosen = await ImagePicker().pickImage(source: ImageSource.gallery,
      imageQuality: 75, maxWidth: 1000, maxHeight: 1000);
    if (chosen == null) return;
    final bytes = await chosen.readAsBytes();
    final isJpeg = bytes.length >= 3 && bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF;
    if (!isJpeg) {
      if (mounted) setState(() => _error = 'Оберіть фото у форматі JPEG (JPG)');
      return;
    }
    if (mounted) setState(() { _newPhoto = bytes; _error = null; });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _busy = true; _error = null; });
    try {
      final repo = ProfileRepository.instance;
      var photoUrl = widget.initial.photoUrl;
      if (_newPhoto != null) photoUrl = await repo.uploadPhoto(widget.uid, _newPhoto!);
      final values = _fields.map((key, value) => MapEntry(key, value.text.trim()));
      await repo.saveProfile(widget.uid, StudentProfile(
        fullName: values['fullName']!, group: values['group']!,
        specialty: values['specialty']!, email: values['email']!,
        studentId: values['studentId']!, about: values['about']!,
        university: values['university']!, photoUrl: photoUrl,
      ));
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) setState(() => _error = 'Не вдалося зберегти: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _field(String key, String title, {int lines = 1}) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(controller: _fields[key], maxLines: lines,
      style: const TextStyle(color: Palette.parchment),
      decoration: InputDecoration(labelText: title),
      validator: (text) => key == 'fullName' && (text == null || text.trim().isEmpty)
        ? 'Вкажіть ім’я' : null),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Редагування профілю')),
    body: SafeArea(child: Form(key: _form, child: ListView(
      padding: const EdgeInsets.all(20), children: [
        const GothicHeading(kicker: 'Особова справа', title: 'Дані студента',
          subtitle: 'Зміни збережуться в Cloud Firestore'),
        const SizedBox(height: 18),
        Center(child: ClipOval(child: _newPhoto != null
          ? Image.memory(_newPhoto!, width: 112, height: 112, fit: BoxFit.cover)
          : widget.initial.photoUrl.isNotEmpty
            ? Image.network(widget.initial.photoUrl, width: 112, height: 112, fit: BoxFit.cover)
            : Image.asset('assets/images/student_photo.png', width: 112, height: 112, fit: BoxFit.cover))),
        TextButton.icon(onPressed: _busy ? null : _choosePhoto,
          icon: const Icon(Icons.photo_library_outlined), label: const Text('Обрати фото з галереї')),
        _field('fullName', 'ПІБ'),
        _field('group', 'Група'),
        _field('specialty', 'Спеціальність'),
        _field('university', 'Навчальний заклад'),
        _field('studentId', 'Номер студентського квитка'),
        _field('email', 'Контактний email'),
        _field('about', 'Інтереси та навички', lines: 3),
        if (_error != null) Text(_error!, style: const TextStyle(color: Colors.redAccent)),
        const SizedBox(height: 12),
        FilledButton(onPressed: _busy ? null : _save,
          child: Text(_busy ? 'Збереження...' : 'Зберегти у Firebase')),
      ],
    ))),
  );
}

class _PaperLine extends StatelessWidget {
  const _PaperLine(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 9), child: Row(children: [
      SizedBox(width: 108, child: Text(label, style: const TextStyle(color: Color(0xFF73584F)))),
      Expanded(child: Text(value.isEmpty ? 'Не вказано' : value,
        style: const TextStyle(color: Color(0xFF38262B), fontWeight: FontWeight.bold))),
    ]));
}

class _InfoLine extends StatelessWidget {
  const _InfoLine(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(color: Palette.muted, fontSize: 12)),
    const SizedBox(height: 4),
    Text(value.isEmpty ? 'Не вказано' : value,
      style: const TextStyle(color: Palette.parchment)),
  ]);
}

class _Message extends StatelessWidget {
  const _Message(this.message);
  final String message;
  @override
  Widget build(BuildContext context) => Center(child: Padding(
    padding: const EdgeInsets.all(24), child: Text(message),
  ));
}
