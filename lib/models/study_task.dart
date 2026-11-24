import 'package:cloud_firestore/cloud_firestore.dart';

class StudyTask {
  const StudyTask({required this.id, required this.title, required this.description,
    required this.deadline, required this.completed, required this.ownerUid});
  final String id;
  final String title;
  final String description;
  final DateTime deadline;
  final bool completed;
  final String ownerUid;

  factory StudyTask.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return StudyTask(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      deadline: (data['deadline'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completed: data['completed'] as bool? ?? false,
      ownerUid: data['ownerUid'] as String? ?? '',
    );
  }
}
