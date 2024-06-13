class Module {
  final int id;
  final int courseId;
  final String title;
  final String learningAchievements;
  final String learningMaterials;
  final String titleYoutube;
  final String descriptionYoutube;
  final String additionalMaterialTitle;
  final String additionalMaterialDescription;
  final String description;
  final String videoLink;
  final String noteLink;

  Module({
    required this.id,
    required this.courseId,
    required this.title,
    required this.learningAchievements,
    required this.learningMaterials,
    required this.titleYoutube,
    required this.descriptionYoutube,
    required this.additionalMaterialTitle,
    required this.additionalMaterialDescription,
    required this.description,
    required this.videoLink,
    required this.noteLink,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      courseId: json['course_id'],
      title: json['title'],
      learningAchievements: json['learning_achievements'],
      learningMaterials: json['learning_materials'],
      titleYoutube: json['title_youtube'],
      descriptionYoutube: json['description_youtube'],
      additionalMaterialTitle: json['additional_material_title'],
      additionalMaterialDescription: json['additional_material_description'],
      description: json['description'],
      videoLink: json['video_link'],
      noteLink: json['note_link'],
    );
  }
}
