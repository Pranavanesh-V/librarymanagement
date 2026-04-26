import 'package:flutter/material.dart';

import '../dataHolder/AppData.dart';
import '../models/book_model.dart';

class BookDetailPage extends StatelessWidget {
  final String bookId;

  const BookDetailPage({
    super.key,
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    // Find book using ID from global loaded books
    final BookModel? book = _findBookById(bookId);

    // If book not found, show fallback screen
    if (book == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Book Details"),
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: Text(
            "Book not found",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    final size = MediaQuery.of(context).size;

    // ✅ SINGLE RESPONSIVE RULE (WEB vs MOBILE)
    final bool useWebLayout = size.width > 700 && size.height > 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),

      appBar: _buildResponsiveAppBar(context, useWebLayout),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1300),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: useWebLayout ? 32 : 14,
                  ),
                  child: _buildResponsiveBody(
                    book,
                    useWebLayout,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= FIND BOOK =================
  BookModel? _findBookById(String id) {
    // 1️⃣ Fast path
    if (AppData.selectedBook?.bookId == id) {
      return AppData.selectedBook;
    }

    // 2️⃣ Full list search
    for (final book in AppData.allBooks) {
      if (book.bookId == id) {
        return book;
      }
    }

    // 3️⃣ fallback
    for (final book in AppData.currentBooks) {
      if (book.bookId == id) {
        return book;
      }
    }

    return null;
  }

  // ================= RESPONSIVE APPBAR =================
  PreferredSizeWidget _buildResponsiveAppBar(
      BuildContext context,
      bool webStyle,
      ) {
    if (webStyle) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Color(0x11000000),
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SafeArea(
              child: Row(
                children: const [
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Book Details",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return AppBar(
      title: const Text("Book Details"),
      centerTitle: true,
      backgroundColor: const Color(0xFF2563EB),
      foregroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
    );
  }

  // ================= RESPONSIVE BODY =================
  Widget _buildResponsiveBody(
      BookModel book,
      bool isWeb,
      ) {
    return Container(
      padding: EdgeInsets.all(isWeb ? 28 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: isWeb
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _bookCover(height: 420),
          ),
          const SizedBox(width: 28),
          Expanded(
            flex: 3,
            child: _bookInfoSection(book, true),
          ),
        ],
      )
          : Column(
        children: [
          _bookCover(height: 240),
          const SizedBox(height: 24),
          _bookInfoSection(book, false),
        ],
      ),
    );
  }

  // ================= BOOK COVER =================
  Widget _bookCover({required double height}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2563EB),
            Color(0xFF1D4ED8),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 100,
          color: Colors.white,
        ),
      ),
    );
  }

  // ================= BOOK INFO =================
  Widget _bookInfoSection(BookModel book, bool largeMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.bookName,
          style: TextStyle(
            fontSize: largeMode ? 30 : 24,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "Detailed information about this book in the library collection.",
          style: TextStyle(
            fontSize: largeMode ? 16 : 14,
            color: Colors.grey,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),
        _detailTile("Book ID", book.bookId),
        _detailTile("Shelf", book.shelf),
        _detailTile("Rack", book.rackId),
      ],
    );
  }

  // ================= DETAIL TILE =================
  Widget _detailTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}