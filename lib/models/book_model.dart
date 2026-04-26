class BookModel {
  final String bookId;
  final String bookName;
  final String shelf;
  final String rackId;

  BookModel({
    required this.bookId,
    required this.bookName,
    required this.shelf,
    required this.rackId,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      bookId: json['bookid'],
      bookName: json['bookname'],
      shelf: json['shelf'],
      rackId: json['rackId'],
    );
  }
}