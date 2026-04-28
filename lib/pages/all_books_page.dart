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
    final List<BookModel> all = AppData.allBooks;

    final List<BookModel> shelfBooks =
    all.where((b) => b.shelf == shelf).toList();

    final String safeTitle = "Shelf $shelf";

    // 🔥 group by rack
    final Map<String, List<BookModel>> groupedByRack = {};
    for (var book in shelfBooks) {
      groupedByRack.putIfAbsent(book.rackId, () => []);
      groupedByRack[book.rackId]!.add(book);
    }

    return Scaffold(
      body: kIsWeb
          ? _buildWebView(context, groupedByRack, safeTitle)
          : _buildMobileView(context, groupedByRack, safeTitle),
    );
  }

  // ================= WEB VIEW =================
  Widget _buildWebView(
      BuildContext context,
      Map<String, List<BookModel>> groupedByRack,
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
                  _webHeader(
                    width,
                    safeTitle,
                    groupedByRack.values.expand((e) => e).length,
                  ),
                  const SizedBox(height: 24),

                  Expanded(
                    child: groupedByRack.isEmpty
                        ? const Center(
                      child: Text(
                        "No books found",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                        : ListView(
                      children: groupedByRack.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 28),
                          child: _buildRackSection(
                            context: context,
                            rackName: entry.key,
                            books: entry.value,
                            isWeb: true,
                            width: width,
                          ),
                        );
                      }).toList(),
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
      Map<String, List<BookModel>> groupedByRack,
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
      body: groupedByRack.isEmpty
          ? const Center(
        child: Text("No books found", style: TextStyle(fontSize: 18)),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 40),
          children: groupedByRack.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _buildRackSection(
                context: context,
                rackName: entry.key,
                books: entry.value,
                isWeb: false,
                width: MediaQuery.of(context).size.width,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ================= RACK SECTION =================
  Widget _buildRackSection({
    required BuildContext context,
    required String rackName,
    required List<BookModel> books,
    required bool isWeb,
    required double width,
  }) {
    final double cardWidth = isWeb
        ? (width > 1400
        ? 260
        : width > 1000
        ? 230
        : 200)
        : width * 0.6;

    final double sectionHeight = isWeb ? 320 : 250;

    final previewBooks = books.take(8).toList(); // preview only

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Rack $rackName",
                style: TextStyle(
                  fontSize: isWeb ? 24 : 20,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _showRackBooksPage(
                  context,
                  rackName,
                  books,
                  isWeb,
                );
              },
              child: const Text("View All"),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: sectionHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: previewBooks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final book = previewBooks[index];

              return SizedBox(
                width: cardWidth,
                child: BookCard(
                  book: book,
                  onTap: () => _openBook(context, book),
                ),
              );
            },
          ),
        ),
      ],
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

  void _openBook(BuildContext context, BookModel book) {
    AppData.selectedBook = book;
    context.push('/book-detail/${book.bookId}');
  }

  void _showRackBooksPage(
      BuildContext context,
      String rackName,
      List<BookModel> books,
      bool isWeb,
      ) {
    AppData.setBooks(books, "Rack $rackName");
    context.push('/rack-books/$rackName');
  }

}