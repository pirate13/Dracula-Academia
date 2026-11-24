import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/study_task.dart';

class TaskRepository {
  TaskRepository._();
  static final instance = TaskRepository._();
  final _db = FirebaseFirestore.instance;

  String get _uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('Спочатку увійдіть до акаунта');
    return user.uid;
  }

  Stream<List<StudyTask>> watchTasks() => _db.collection('tasks')
      .where('ownerUid', isEqualTo: _uid)
      .snapshots()
      .map((snapshot) {
        final tasks = snapshot.docs.map(StudyTask.fromDocument).toList();
        tasks.sort((a, b) => a.deadline.compareTo(b.deadline));
        return tasks;
      });

  Future<void> addTask(String title, String description, DateTime deadline) async {
    await _db.collection('tasks').add({
      'title': title, 'description': description,
      'deadline': Timestamp.fromDate(deadline), 'completed': false,
      'ownerUid': _uid,
    });
  }

  Future<void> updateTask(StudyTask task, String title, String description, DateTime deadline) async {
    await _db.collection('tasks').doc(task.id).update({
      'title': title, 'description': description,
      'deadline': Timestamp.fromDate(deadline),
    });
  }

  Future<void> setCompleted(StudyTask task, bool value) async {
    await _db.collection('tasks').doc(task.id).update({'completed': value});
  }

  Future<void> deleteTask(StudyTask task) async {
    await _db.collection('tasks').doc(task.id).delete();
  }
}
