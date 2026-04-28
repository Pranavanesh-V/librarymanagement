import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../dataHolder/AppData.dart';
import '../models/book_model.dart';
import '../widgets/book_card.dart';

class RackBooksPage extends StatelessWidget {
  final String rack;

  const RackBooksPage({super.key, required this.rack});

  @override
  Widget build(BuildContext context) {
    final List<BookModel> books = AppData.currentBooks;
    final String title = "Rack $rack";

    return Scaffold(
      body: kIsWeb
          ? _buildWebView(context, books, title)
          : _buildMobileView(context, books, title),
    );
  }

  Widget _buildWebView(
      BuildContext context,
      List<BookModel> books,
      String title,
      ) {
    final width = MediaQuery.of(context).size.width;

    // Handle smaller browser widths like mobile/tablet on web
    final bool isSmallWeb = width < 700;

    final int crossAxisCount = isSmallWeb
        ? 2
        : width > 1400
        ? 5
        : width > 1000
        ? 4
        : 3;

    final double aspectRatio = isSmallWeb ? 0.62 : 0.72;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1700),
            child: Padding(
              padding: EdgeInsets.all(isSmallWeb ? 12 : 24),
              child: Column(
                children: [
                  _header(width, title, books.length),
                  SizedBox(height: isSmallWeb ? 16 : 24),
                  Expanded(
                    child: GridView.builder(
                      itemCount: books.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: isSmallWeb ? 12 : 18,
                        mainAxisSpacing: isSmallWeb ? 12 : 18,
                        childAspectRatio: aspectRatio,
                      ),
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return BookCard(
                          book: book,
                          onTap: () => _openBook(context, book),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileView(
      BuildContext context,
      List<BookModel> books,
      String title,
      ) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: books.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.68,
          ),
          itemBuilder: (context, index) {
            final book = books[index];
            return BookCard(
              book: book,
              onTap: () => _openBook(context, book),
            );
          },
        ),
      ),
    );
  }

  Widget _header(double width, String title, int totalBooks) {
    final bool isSmall = width < 700;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 16 : 24,
        vertical: isSmall ? 16 : 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isSmall
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "$totalBooks Books",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      )
          : Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: width > 1400 ? 30 : 26,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              "$totalBooks Books",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openBook(BuildContext context, BookModel book) {
    AppData.selectedBook = book;
    context.push('/book-detail/${book.bookId}');
  }
}