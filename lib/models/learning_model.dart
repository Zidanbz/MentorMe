class Learning {
  final String id;
  final String idProject;
  final bool progress;
  final Project project;

  Learning({
    required this.id,
    required this.idProject,
    required this.progress,
    required this.project,
  });

  factory Learning.fromJson(Map<String, dynamic> json) {
    return Learning(
      id: json['ID'] ?? '',
      idProject: json['IDProject'] ?? '',
      progress: json['progress'] ?? false,
      project: Project.fromJson(json['project']),
    );
  }
}

class Project {
  final String materialName;
  final String picture;
  final int student;

  Project({
    required this.materialName,
    required this.picture,
    required this.student,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      materialName: json['materialName'] ?? '',
      picture: json['picture'] ?? '',
      student: json['student'] ?? 0,
    );
  }
}
