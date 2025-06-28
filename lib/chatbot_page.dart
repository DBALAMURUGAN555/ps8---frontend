import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatbotPage extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  const ChatbotPage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              FlutterLogo(size: 28),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  'PollutionVIZ',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            tooltip: 'Toggle Dark Mode',
            onPressed: onToggleTheme,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const _ChatbotBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: isDark ? Colors.white : Colors.green,
        unselectedItemColor: isDark ? const Color(0xFFB0B3B8) : Colors.black54,
        backgroundColor: isDark ? const Color(0xFF23242B) : Colors.white,
        onTap: (_) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_in_ar),
            label: 'Scenarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }
}

class _ChatbotBody extends StatelessWidget {
  const _ChatbotBody();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        const SizedBox(height: 32),
        Center(
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2DE3A7) : Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.smart_toy_rounded,
                  color: isDark ? Colors.white : Colors.green,
                  size: 48,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Clarity",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Your pollution awareness assistant",
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 18),
              // Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ChatTab(label: "Help", selected: true),
                    _ChatTab(label: "Compare Locations"),
                    _ChatTab(label: "Health Risks"),
                    _ChatTab(label: "Policy Tips"),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 3,
                width: 80,
                margin: const EdgeInsets.only(left: 8),
                color: isDark ? Colors.greenAccent : Colors.green,
              ),
              const SizedBox(height: 18),
              // Chat bubble
              Container(
                width: 320,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF23242B) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Text(
                  "Hello! I'm Clarity, your pollution awareness assistant. I can help you with pollution definitions, location comparisons, health risks, policy suggestions, and daily tips. How can I assist you today?",
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              // Input
              Container(
                width: 320,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF23242B) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Ask me about pollution...",
                          hintStyle: GoogleFonts.montserrat(
                            color: isDark ? Colors.white54 : Colors.grey,
                          ),
                        ),
                        style: GoogleFonts.montserrat(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2DE3A7) : Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatTab extends StatelessWidget {
  final String label;
  final bool selected;
  const _ChatTab({required this.label, this.selected = false});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? (isDark ? const Color(0xFF2DE3A7) : Colors.green)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          color: selected
              ? Colors.white
              : (isDark ? Colors.white70 : Colors.black87),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}