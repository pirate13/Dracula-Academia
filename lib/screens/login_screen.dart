import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/profile_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false, _busy = false;
  String? _error;

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _busy = true; _error = null; });
    try {
      if (_register) {
        await ProfileRepository.instance.register(_email.text, _password.text);
      } else {
        await ProfileRepository.instance.signIn(_email.text, _password.text);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() => _error = switch(e.code) {
        'email-already-in-use' => 'Цю пошту вже зареєстровано',
        'invalid-email' => 'Неправильна адреса пошти',
        'weak-password' => 'Пароль надто простий',
        'invalid-credential' => 'Невірна пошта або пароль',
        _ => 'Помилка входу: ${e.message ?? e.code}',
      });
    } catch (e) {
      if (mounted) setState(() => _error = 'Помилка: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Center(child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 440),
        child: Form(key: _form, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Icon(Icons.castle, size: 76, color: Palette.gold),
          const SizedBox(height: 20),
          const GothicHeading(kicker: 'DRACULA ACADEMIA', title: 'Вхід до академії', subtitle: 'Ваш профіль зберігається у Firebase'),
          const SizedBox(height: 24),
          GothicCard(child: Column(children: [
            TextFormField(controller: _email, keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Palette.parchment),
              decoration: const InputDecoration(labelText: 'Електронна пошта'),
              validator: (v) => v == null || !v.contains('@') ? 'Введіть електронну пошту' : null),
            const SizedBox(height: 12),
            TextFormField(controller: _password, obscureText: true,
              style: const TextStyle(color: Palette.parchment),
              decoration: const InputDecoration(labelText: 'Пароль'),
              validator: (v) => v == null || v.length < 6 ? 'Мінімум 6 символів' : null),
          ])),
          if (_error != null) Padding(padding: const EdgeInsets.only(top: 12),
            child: Text(_error!, style: const TextStyle(color: Colors.redAccent))),
          const SizedBox(height: 18),
          FilledButton(onPressed: _busy ? null : _submit,
            child: Text(_busy ? 'Зачекайте...' : _register ? 'Створити акаунт' : 'Увійти')),
          TextButton(onPressed: _busy ? null : () => setState(() {
            _register = !_register; _error = null;
          }), child: Text(_register ? 'Уже є акаунт? Увійти' : 'Немає акаунта? Зареєструватися')),
        ])),
      ),
    ))),
  );
}
