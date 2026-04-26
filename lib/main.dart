import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:librarymanagement/pages/all_books_page.dart';
import 'package:librarymanagement/pages/book_detail_page.dart';
import 'package:librarymanagement/pages/home_page.dart';
import 'package:librarymanagement/pages/landing_page.dart';


void main() {
  runApp(const LibraryApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),

    // ALL BOOKS
    GoRoute(
      path: '/all-books/:shelf',
      builder: (context, state) {
        final shelf = state.pathParameters['shelf']!;
        return AllBooksPage(shelf: shelf);
      },
    ),

    // BOOK DETAILS
    GoRoute(
      path: '/book-detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BookDetailPage(bookId: id);
      },
    ),
  ],

  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text("Page not found: ${state.uri}")),
  ),
);

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'University Library',
      theme: ThemeData(useMaterial3: true),
      routerConfig: _router,
    );
  }
}