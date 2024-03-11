// ignore_for_file: file_names

class CategoriesModel {
  final String categoryId;
  final String categoryImg;
  final String categoryName;

  CategoriesModel({
    required this.categoryId,
    required this.categoryImg,
    required this.categoryName,
  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryImg': categoryImg,
      'categoryName': categoryName,
    };
  }

  // Create a UserModel instance from a JSON map
  factory CategoriesModel.fromMap(Map<String, dynamic> json) {
    return CategoriesModel(
      categoryId: json['categoryId'],
      categoryImg: json['categoryImg'],
      categoryName: json['categoryName'],
    );
  }
}
