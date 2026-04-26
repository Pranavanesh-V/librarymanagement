import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../dataHolder/AppData.dart';
import '../models/book_model.dart';
import '../widgets/book_card.dart';

class AllBooksPage extends StatelessWidget {
  final String shelf;

  const AllBooksPage({super.key, required this.shelf});

  @override
  Widget build(BuildContext context) {
    // 1️⃣ SINGLE SOURCE OF TRUTH
    final List<BookModel> all = AppData.allBooks;

    // 2️⃣ FILTER BY SHELF (SAFE)
    final List<BookModel> shelfBooks = all
        .where((b) => b.shelf == shelf)
        .toList();

    // 3️⃣ FINAL BOOK LIST (NO FALLBACK NEEDED)
    final List<BookModel> safeBooks = shelfBooks;

    // 4️⃣ TITLE
    final String safeTitle = "Shelf $shelf";

    return Scaffold(
      body: kIsWeb
          ? _buildWebView(context, safeBooks, safeTitle)
          : _buildMobileView(context, safeBooks, safeTitle),
    );
  }

  // ================= WEB VIEW =================
  Widget _buildWebView(
    BuildContext context,
    List<BookModel> safeBooks,
    String safeTitle,
  ) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1700),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                children: [
                  _webHeader(width, safeTitle, safeBooks.length),
                  const SizedBox(height: 24),

                  Expanded(
                    child: safeBooks.isEmpty
                        ? const Center(
                            child: Text(
                              "No books found",
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : GridView.builder(
                            itemCount: safeBooks.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _webGridCount(width),
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: _webAspectRatio(width),
                                ),
                            itemBuilder: (context, index) {
                              final book = safeBooks[index];

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

  // ================= MOBILE VIEW =================
  Widget _buildMobileView(
    BuildContext context,
    List<BookModel> safeBooks,
    String safeTitle,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),

      appBar: AppBar(
        title: Text(safeTitle),
        centerTitle: true,
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),

      body: safeBooks.isEmpty
          ? const Center(
              child: Text("No books found", style: TextStyle(fontSize: 18)),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: false,
                removeLeft: false,
                removeRight: false,
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 50), // 🔥 important
                  physics: const BouncingScrollPhysics(),
                  itemCount: safeBooks.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (context, index) {
                    final book = safeBooks[index];

                    return BookCard(
                      book: book,
                      onTap: () => _openBook(context, book),
                    );
                  },
                ),
              ),
            ),
    );
  }

  // ================= WEB HEADER =================
  Widget _webHeader(double width, String safeTitle, int totalBooks) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
      child: Row(
        children: [
          Expanded(
            child: Text(
              safeTitle,
              style: TextStyle(
                fontSize: width > 1400 ? 30 : 26,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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

  // ================= HELPERS =================
  int _webGridCount(double width) {
    if (width >= 1800) return 6;
    if (width >= 1450) return 5;
    if (width >= 1100) return 4;
    if (width >= 850) return 3;
    return 2;
  }

  double _webAspectRatio(double width) {
    if (width >= 1450) return 0.74;
    if (width >= 1100) return 0.72;
    if (width >= 850) return 0.70;
    return 0.68;
  }

  void _openBook(BuildContext context, BookModel book) {
    // 1️⃣ Always sync global state
    AppData.selectedBook = book;

    // 2️⃣ Navigate using ID only (clean architecture)
    context.push('/book-detail/${book.bookId}');
  }
}
