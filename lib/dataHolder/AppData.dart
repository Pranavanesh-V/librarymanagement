import '../models/book_model.dart';

class AppData {
  static List<BookModel> allBooks = [];
  static List<BookModel> currentBooks = [];
  static String currentTitle = "All Books";
  static BookModel? selectedBook;

  static void setBooks(List<BookModel> books, String title) {
    currentBooks = books;
    currentTitle = title;
  }

  static List<BookModel> getBooksByShelf(String shelf) {
    return allBooks.where((b) => b.shelf == shelf).toList();
  }
}