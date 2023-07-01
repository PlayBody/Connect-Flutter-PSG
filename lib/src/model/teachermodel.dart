class TeacherModel {
  final String teacherId;
  final String teacherName;

  const TeacherModel({
    required this.teacherId,
    required this.teacherName,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      teacherId: json['teacher_id'],
      teacherName: json['teacher_name'],
    );
  }
}
