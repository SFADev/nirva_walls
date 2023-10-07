class CollectionsModel {
  String? title;

  bool? private;
  CollectionsModel({this.title, this.private});

  factory CollectionsModel.fromMap(Map<String, dynamic> parsedJson) {
    return CollectionsModel(
      title: parsedJson["title"],
      private: parsedJson["private"],
    );
  }
}
