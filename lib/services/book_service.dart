import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/book_model.dart';

class BookService {
  static Future<List<BookModel>> loadBooks() async {
    final String response =
    await rootBundle.loadString('assets/final_database_clean.json');
    final List data = json.decode(response);

    return data.map((e) => BookModel.fromJson(e)).toList();
  }
}