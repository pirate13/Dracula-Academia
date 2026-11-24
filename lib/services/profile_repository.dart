import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/student_profile.dart';

class ProfileRepository {
  ProfileRepository._();
  static final instance = ProfileRepository._();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  User? get currentUser => auth.currentUser;
  Stream<User?> authChanges() => auth.authStateChanges();

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      firestore.collection('students').doc(uid);

  Stream<StudentProfile?> watchProfile(String uid) => _doc(uid).snapshots().map(
    (snapshot) => snapshot.exists && snapshot.data() != null
        ? StudentProfile.fromMap(snapshot.data()!)
        : null,
  );

  Future<void> signIn(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email.trim(), password: password);
  }

  Future<void> register(String email, String password) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email.trim(), password: password,
    );
    final user = credential.user!;
    await _doc(user.uid).set(StudentProfile(
      fullName: '', group: '', specialty: 'Комп’ютерні науки',
      email: user.email ?? email.trim(), studentId: '', about: '', university: '',
    ).toMap());
  }

  Future<void> saveProfile(String uid, StudentProfile profile) =>
      _doc(uid).set(profile.toMap(), SetOptions(merge: true));

  Future<String> uploadPhoto(String uid, Uint8List bytes) async {
    if (bytes.lengthInBytes > 5 * 1024 * 1024) {
      throw Exception('Фото має бути меншим за 5 МБ');
    }
    final ref = storage.ref('student_photos/$uid/profile.jpg');
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }

  Future<void> signOut() => auth.signOut();
}
