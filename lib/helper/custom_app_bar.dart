import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Color? lightModeTextColor;
  final Color? darkModeTextColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.lightModeTextColor = const Color(0xCC0D47A1), // 80% opacity blue
    this.darkModeTextColor = Colors.white, // White in dark mode
    this.actions,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Choose text color based on theme
    final textColor = isDark ? darkModeTextColor : lightModeTextColor;
    // Fallback to theme colors if custom colors are null
    final effectiveTextColor = textColor ?? theme.appBarTheme.titleTextStyle?.color;

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: effectiveTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
              Colors.blue.shade900.withOpacity(0.8),
              Colors.indigo.shade800.withOpacity(0.8),
            ]
                : [
              Colors.blue.shade50.withOpacity(0.9),
              Colors.lightBlue.shade100.withOpacity(0.9),
            ],
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: effectiveTextColor, // Makes back button and icons visible
      ),
      actions: actions?.map((action) {
        // Ensure action icons use the correct color
        if (action is IconButton) {
          return IconButton(
            icon: Icon(
              action.icon as IconData?,
              color: effectiveTextColor,
            ),
            onPressed: action.onPressed,
          );
        }
        return action;
      }).toList(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}