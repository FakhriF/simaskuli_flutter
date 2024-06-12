class CourseBuilding {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String learningOutcomes;
  final int userId;
  final int buildingId;
  final String buildingName;
  final double longitude;
  final double latitude;

  CourseBuilding({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.learningOutcomes,
    required this.userId,
    required this.buildingId,
    required this.buildingName,
    required this.longitude,
    required this.latitude,
  });

  factory CourseBuilding.fromJson(Map<String, dynamic> json) {
    return CourseBuilding(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      learningOutcomes: json['learning_outcomes'],
      userId: json['user_id'],
      buildingId: json['building_id'],
      buildingName: json['building_name'],
      longitude: double.parse(json['longitude']),
      latitude: double.parse(json['latitude']),
    );
  }
}
