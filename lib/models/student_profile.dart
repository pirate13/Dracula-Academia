class StudentProfile {
  const StudentProfile({
    required this.fullName,
    required this.group,
    required this.specialty,
    required this.email,
    required this.studentId,
    required this.about,
    required this.university,
    this.photoUrl = '',
  });

  final String fullName, group, specialty, email, studentId, about, university, photoUrl;

  factory StudentProfile.fromMap(Map<String, dynamic> data) => StudentProfile(
    fullName: (data['fullName'] ?? '').toString(),
    group: (data['group'] ?? '').toString(),
    specialty: (data['specialty'] ?? '').toString(),
    email: (data['email'] ?? '').toString(),
    studentId: (data['studentId'] ?? '').toString(),
    about: (data['about'] ?? '').toString(),
    university: (data['university'] ?? '').toString(),
    photoUrl: (data['photoUrl'] ?? '').toString(),
  );

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'group': group,
    'specialty': specialty,
    'email': email,
    'studentId': studentId,
    'about': about,
    'university': university,
    'photoUrl': photoUrl,
  };

  StudentProfile copyWith({String? photoUrl}) => StudentProfile(
    fullName: fullName, group: group, specialty: specialty, email: email,
    studentId: studentId, about: about, university: university,
    photoUrl: photoUrl ?? this.photoUrl,
  );
}
