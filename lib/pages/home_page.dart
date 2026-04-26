import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../dataHolder/AppData.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';
import 'package:go_router/go_router.dart';
import '../widgets/book_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BookModel> allBooks = [];
  List<BookModel> filteredBooks = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    final books = await BookService.loadBooks();

    setState(() {
      AppData.allBooks = books; // 🔥 IMPORTANT FIX
      filteredBooks = books;
      isLoading = false;
    });
  }

  void searchBooks(String query) {
    setState(() {
      filteredBooks = allBooks.where((book) {
        return book.bookName.toLowerCase().contains(query.toLowerCase()) ||
            book.bookId.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Map<String, List<BookModel>> groupByShelf(List<BookModel> books) {
    final grouped = <String, List<BookModel>>{};

    for (var book in books) {
      grouped.putIfAbsent(book.shelf, () => []);
      grouped[book.shelf]!.add(book);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final groupedBooks = groupByShelf(filteredBooks);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: kIsWeb
          ? _buildResponsiveWebUI(context, groupedBooks)
          : _buildMobileUI(context, groupedBooks),
    );
  }

  // =========================================================
  // RESPONSIVE WEB UI (desktop / tablet / mobile browser)
  // =========================================================
  Widget _buildResponsiveWebUI(
    BuildContext context,
    Map<String, List<BookModel>> groupedBooks,
  ) {
    final width = MediaQuery.of(context).size.width;

    double maxContentWidth;
    double horizontalPadding;
    double searchWidth;
    double sectionHeight;
    double titleSize;
    double headerSpacing;

    if (width >= 1600) {
      maxContentWidth = 1500;
      horizontalPadding = 40;
      searchWidth = 420;
      sectionHeight = 320;
      titleSize = 28;
      headerSpacing = 30;
    } else if (width >= 1200) {
      maxContentWidth = 1300;
      horizontalPadding = 28;
      searchWidth = 380;
      sectionHeight = 300;
      titleSize = 26;
      headerSpacing = 26;
    } else if (width >= 900) {
      maxContentWidth = 1000;
      horizontalPadding = 22;
      searchWidth = 320;
      sectionHeight = 280;
      titleSize = 24;
      headerSpacing = 22;
    } else {
      maxContentWidth = 700;
      horizontalPadding = 16;
      searchWidth = width * 0.9;
      sectionHeight = 260;
      titleSize = 22;
      headerSpacing = 18;
    }

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: [
                const SizedBox(height: 18),

                // HEADER
                _buildWebHeader(searchWidth: searchWidth, width: width),

                const SizedBox(height: 20),

                // CONTENT
                Expanded(
                  child: ListView(
                    children: groupedBooks.entries.map((entry) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: headerSpacing),
                        child: _buildShelfSection(
                          context: context,
                          entry: entry,
                          height: sectionHeight,
                          titleSize: titleSize,
                          isWeb: true,
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
    );
  }

  Widget _buildWebHeader({required double searchWidth, required double width}) {
    final isCompact = width < 900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
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
      child: isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.local_library, color: Colors.indigo, size: 30),
                    SizedBox(width: 10),
                    Text(
                      "Library Portal",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(width: double.infinity, child: _buildSearchField()),
              ],
            )
          : Row(
              children: [
                const Icon(Icons.local_library, color: Colors.indigo, size: 34),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Library Portal",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                ),
                SizedBox(width: searchWidth, child: _buildSearchField()),
              ],
            ),
    );
  }

  // =========================================================
  // MOBILE APP UI
  // =========================================================
  Widget _buildMobileUI(
      BuildContext context,
      Map<String, List<BookModel>> groupedBooks,
      ) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Padding(
        padding: EdgeInsets.only(
          left: 14,
          right: 14,
          top: topPadding + 10, // 🔥 important fix
          bottom: 14,
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.menu_book_rounded,
                      color: Colors.indigo, size: 28),
                  SizedBox(width: 10),
                  Text(
                    "University Library",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildSearchField(),

            const SizedBox(height: 18),

            Expanded(
              child: ListView(
                children: groupedBooks.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: _buildShelfSection(
                      context: context,
                      entry: entry,
                      height: 235,
                      titleSize: 20,
                      isWeb: false,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // COMMON WIDGETS
  // =========================================================
  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      onChanged: searchBooks,
      decoration: InputDecoration(
        hintText: "Search books...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildShelfSection({
    required BuildContext context,
    required MapEntry<String, List<BookModel>> entry,
    required double height,
    required double titleSize,
    required bool isWeb,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Shelf ${entry.key}",
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                AppData.setBooks(entry.value, "Shelf ${entry.key}");
                context.push('/all-books/${entry.key}');
              },
              child: const Text("View All"),
            ),
          ],
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = MediaQuery.of(context).size.width;

            // Responsive card width based on screen size
            double cardWidth;
            if (screenWidth >= 1600) {
              cardWidth = 300;
            } else if (screenWidth >= 1200) {
              cardWidth = 260;
            } else if (screenWidth >= 900) {
              cardWidth = 230;
            } else if (screenWidth >= 600) {
              cardWidth = 200;
            } else {
              cardWidth = screenWidth * 0.65;
            }

            return SizedBox(
              height: height,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: entry.value.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final book = entry.value[index];

                  return SizedBox(
                    width: cardWidth,
                    child: BookCard(
                      book: book,
                      onTap: () => _openBook(context, book),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void _openBook(BuildContext context, BookModel book) {
    AppData.selectedBook = book;
    context.push('/book-detail/${book.bookId}');
  }
}
