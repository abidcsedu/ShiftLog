import 'package:flutter/material.dart';

import '../../domain/enums.dart';
import '../theme.dart';

/// Consistent, color-coded chip for a work mode (icon + label).
class ModeChip extends StatelessWidget {
  final WorkMode mode;
  final bool compact;
  const ModeChip(this.mode, {super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final v = modeVisual(mode);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 10, vertical: compact ? 4 : 6),
      decoration: BoxDecoration(
        color: v.color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(v.icon, size: compact ? 14 : 16, color: v.color),
          const SizedBox(width: 6),
          Text(
            mode.label,
            style: TextStyle(
              color: v.color,
              fontWeight: FontWeight.w600,
              fontSize: compact ? 12 : 13,
            ),
          ),
        ],
      ),
    );
  }
}
