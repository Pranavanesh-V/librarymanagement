import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: kIsWeb
          ? _buildResponsiveWebUI(context)
          : _buildMobileUI(context),
    );
  }

  // ---------------- RESPONSIVE WEB UI ----------------
  Widget _buildResponsiveWebUI(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isLargeDesktop = width > 1400;
    final bool isTabletWeb = width < 1000;

    return Container(
      color: const Color(0xFFF8FAFC),
      child: SafeArea(
        child: Column(
          children: [
            // NAVBAR
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isLargeDesktop ? 50 : 24,
                vertical: 18,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1500),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_library,
                        color: Colors.indigo,
                        size: 34,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "University Library Portal",
                          style: TextStyle(
                            fontSize: isTabletWeb ? 20 : 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // HERO SECTION
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1500),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isLargeDesktop ? 50 : 24,
                      vertical: 30,
                    ),
                    child: isTabletWeb
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildVisualCard(
                          height: 280,
                          iconSize: 100,
                        ),
                        const SizedBox(height: 30),
                        _buildTextSection(
                          context,
                          titleSize: 34,
                          bodySize: 17,
                          centered: true,
                        ),
                      ],
                    )
                        : Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: _buildTextSection(
                            context,
                            titleSize: isLargeDesktop ? 56 : 46,
                            bodySize: 20,
                            centered: false,
                          ),
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          flex: 4,
                          child: _buildVisualCard(
                            height: isLargeDesktop ? 520 : 430,
                            iconSize: isLargeDesktop ? 180 : 140,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- WEB TEXT ----------------
  Widget _buildTextSection(
      BuildContext context, {
        required double titleSize,
        required double bodySize,
        required bool centered,
      }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
      centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          "A Modern Library Experience",
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Search, explore, and access university books through a centralized digital platform.",
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: bodySize,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 35),
        ElevatedButton(
          onPressed: () => _navigate(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 36,
              vertical: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            "Enter Library",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  // ---------------- VISUAL CARD ----------------
  Widget _buildVisualCard({
    required double height,
    required double iconSize,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Colors.indigo, Colors.blueAccent],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 25,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    );
  }

  // ---------------- MOBILE APP UI ----------------
  Widget _buildMobileUI(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_library,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              const Text(
                "University Library Management",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "Access books instantly and explore the university catalog.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _navigate(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Enter Library",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context) {
    context.push('/home');
  }

}