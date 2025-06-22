class PersonModel {
  final String id;
  final String name;

  PersonModel({required this.id, required this.name});

  factory PersonModel.fromMap(Map<String, dynamic> map, String docId) {
    return PersonModel(
      id: docId,
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
