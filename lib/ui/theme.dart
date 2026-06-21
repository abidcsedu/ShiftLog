import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../domain/enums.dart';

/// Central design system for ShiftLog — a refined, cool-tinted dark palette
/// with a modern typeface and an ocean blue→cyan brand gradient.
class AppTheme {
  static const Color seed = Color(0xFF3B82F6); // blue-500

  /// Signature accent gradient used on the ring, primary actions, etc.
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: seed);
    return _build(scheme);
  }

  static ThemeData dark() {
    final base = ColorScheme.fromSeed(
        seedColor: seed, brightness: Brightness.dark);
    // Cool near-black surfaces with clear elevation steps for real depth.
    final scheme = base.copyWith(
      primary: const Color(0xFF60A5FA),
      onPrimary: const Color(0xFF07203A),
      surface: const Color(0xFF0E1014),
      onSurface: const Color(0xFFECEEF2),
      onSurfaceVariant: const Color(0xFF9BA1AE),
      surfaceContainerLowest: const Color(0xFF0A0C0F),
      surfaceContainerLow: const Color(0xFF141720),
      surfaceContainer: const Color(0xFF181B24),
      surfaceContainerHigh: const Color(0xFF1D212B),
      surfaceContainerHighest: const Color(0xFF262B37),
      outlineVariant: const Color(0xFF2B2F3A),
    );
    return _build(scheme);
  }

  static ThemeData _build(ColorScheme scheme) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      ThemeData(brightness: scheme.brightness).textTheme,
    ).apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        centerTitle: false,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        highlightElevation: 0,
        extendedTextStyle:
            textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide.none,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        elevation: 0,
        height: 66,
        indicatorColor: scheme.primary.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.all(textTheme.labelMedium
            ?.copyWith(fontWeight: FontWeight.w600, fontSize: 12)),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.6),
        space: 1,
      ),
    );
  }
}

/// Visual identity for each work mode, kept consistent across every screen.
class ModeVisual {
  final Color color;
  final IconData icon;
  const ModeVisual(this.color, this.icon);
}

/// Icon + accent for a note type (built-in or custom).
({IconData icon, Color color}) noteTypeVisual(String kind) => switch (kind) {
      kNoteDaily => (icon: Icons.today, color: const Color(0xFF3B82F6)),
      kNoteMeeting => (icon: Icons.groups, color: const Color(0xFF0D9488)),
      _ => (icon: Icons.label_outline, color: const Color(0xFF64748B)),
    };

ModeVisual modeVisual(WorkMode mode) => switch (mode) {
      WorkMode.office => const ModeVisual(Color(0xFF3B82F6), Icons.business),
      WorkMode.wfh => const ModeVisual(Color(0xFF2DD4BF), Icons.home_work),
      WorkMode.outside =>
        const ModeVisual(Color(0xFFFB923C), Icons.directions_walk),
    };
