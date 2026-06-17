import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';
import '../../services/haptic_service.dart';

/// Duolingo-style tap-to-match: pair Japanese with English meanings.
class MatchPairsWidget extends StatefulWidget {
  const MatchPairsWidget({
    super.key,
    required this.pairs,
    required this.onComplete,
    this.showFeedback = false,
    this.isCorrect = false,
  });

  final Map<String, String> pairs;
  final VoidCallback onComplete;
  final bool showFeedback;
  final bool isCorrect;

  @override
  State<MatchPairsWidget> createState() => _MatchPairsWidgetState();
}

class _MatchPairsWidgetState extends State<MatchPairsWidget> {
  String? _selectedLeft;
  final Set<String> _matchedLeft = {};
  final Set<String> _matchedRight = {};
  String? _wrongLeft;
  String? _wrongRight;

  List<String> get _leftItems => widget.pairs.keys.toList();
  List<String> get _rightItems {
    final items = widget.pairs.values.toList()..shuffle();
    return items;
  }

  late final List<String> _shuffledRight = _rightItems;

  void _tapLeft(String item) {
    if (widget.showFeedback || _matchedLeft.contains(item)) return;
    setState(() {
      _selectedLeft = item;
      _wrongLeft = null;
      _wrongRight = null;
    });
    HapticService.selection();
  }

  void _tapRight(String item) {
    if (widget.showFeedback || _selectedLeft == null) return;
    if (_matchedRight.contains(item)) return;

    final expected = widget.pairs[_selectedLeft!];
    if (expected == item) {
      HapticService.correctAnswer();
      setState(() {
        _matchedLeft.add(_selectedLeft!);
        _matchedRight.add(item);
        _selectedLeft = null;
      });
      if (_matchedLeft.length == widget.pairs.length) {
        widget.onComplete();
      }
    } else {
      HapticService.wrongAnswer();
      setState(() {
        _wrongLeft = _selectedLeft;
        _wrongRight = item;
        _selectedLeft = null;
      });
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _wrongLeft = null;
            _wrongRight = null;
          });
        }
      });
    }
  }

  Color _leftColor(String item) {
    if (widget.showFeedback && widget.isCorrect) {
      return AppColors.success.withValues(alpha: 0.15);
    }
    if (_matchedLeft.contains(item)) {
      return AppColors.success.withValues(alpha: 0.2);
    }
    if (_wrongLeft == item) {
      return AppColors.error.withValues(alpha: 0.15);
    }
    if (_selectedLeft == item) {
      return AppColors.secondary.withValues(alpha: 0.15);
    }
    return Colors.white;
  }

  Color _rightColor(String item) {
    if (widget.showFeedback && widget.isCorrect) {
      return AppColors.success.withValues(alpha: 0.15);
    }
    if (_matchedRight.contains(item)) {
      return AppColors.success.withValues(alpha: 0.2);
    }
    if (_wrongRight == item) {
      return AppColors.error.withValues(alpha: 0.15);
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: _leftItems.map((item) {
              final matched = _matchedLeft.contains(item);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MatchTile(
                  label: item,
                  color: _leftColor(item),
                  borderColor: matched
                      ? AppColors.success
                      : (_selectedLeft == item
                          ? AppColors.secondary
                          : AppColors.skillPath),
                  onTap: () => _tapLeft(item),
                  matched: matched,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: _shuffledRight.map((item) {
              final matched = _matchedRight.contains(item);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MatchTile(
                  label: item,
                  color: _rightColor(item),
                  borderColor:
                      matched ? AppColors.success : AppColors.skillPath,
                  onTap: () => _tapRight(item),
                  matched: matched,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _MatchTile extends StatelessWidget {
  const _MatchTile({
    required this.label,
    required this.color,
    required this.borderColor,
    required this.onTap,
    required this.matched,
  });

  final String label;
  final Color color;
  final Color borderColor;
  final VoidCallback onTap;
  final bool matched;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: matched ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: matched
                ? AppColors.successDark
                : AppColors.lightText,
            decoration: matched ? TextDecoration.lineThrough : null,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
