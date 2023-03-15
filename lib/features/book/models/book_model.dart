import 'dart:convert';

class BookModel {
  final String title;
  final String author;
  final String description;
  final String image;
  final String id;
  final String progress;
  BookModel({
    required this.title,
    required this.author,
    required this.description,
    required this.image,
    required this.id,
    required this.progress,
  });

  BookModel copyWith({
    String? title,
    String? author,
    String? description,
    String? image,
    String? id,
    String? progress,
  }) {
    return BookModel(
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      image: image ?? this.image,
      id: id ?? this.id,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'author': author,
      'description': description,
      'image': image,
      'id': id,
      'progress': progress,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      title: map['title'] as String,
      author: map['author'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      id: map['id'] as String,
      progress: map['progress'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookModel.fromJson(String source) =>
      BookModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BookModel(title: $title, author: $author, description: $description, image: $image, id: $id, progress: $progress)';
  }

  @override
  bool operator ==(covariant BookModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.author == author &&
        other.description == description &&
        other.image == image &&
        other.id == id &&
        other.progress == progress;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        author.hashCode ^
        description.hashCode ^
        image.hashCode ^
        id.hashCode ^
        progress.hashCode;
  }
}
