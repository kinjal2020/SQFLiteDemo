class ToDoModel {
  final int id;
  final String title;
  final String describtion;

  ToDoModel({required this.title, required this.id, required this.describtion});

  factory ToDoModel.fromJson(Map<String, dynamic> map) {
    return ToDoModel(
      title: map['title'],
      id: map['id'],
      describtion: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'description': describtion,
    };
  }
}
