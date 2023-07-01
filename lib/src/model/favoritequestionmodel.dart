class FavoriteQuestionModel {
  final String id;
  final String question;
  final String answer;

  const FavoriteQuestionModel(
      {required this.id, required this.question, required this.answer});

  factory FavoriteQuestionModel.fromJson(Map<String, dynamic> json) {
    return FavoriteQuestionModel(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}
