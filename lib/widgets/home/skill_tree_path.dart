import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../data/course_repository.dart';
import '../../models/lesson_models.dart';

enum SkillNodeStatus { completed, current, locked, chest }

class SkillTreeNode {
  const SkillTreeNode({
    required this.lesson,
    required this.status,
    required this.moduleColor,
    this.isModuleStart = false,
    this.moduleTitle,
  });

  final LessonModel lesson;
  final SkillNodeStatus status;
  final Color moduleColor;
  final bool isModuleStart;
  final String? moduleTitle;
}

class SkillTreePath extends StatelessWidget {
  const SkillTreePath({
    super.key,
    required this.nodes,
    required this.onNodeTap,
  });

  final List<SkillTreeNode> nodes;
  final void Function(LessonModel lesson) onNodeTap;

  static List<SkillTreeNode> buildNodes(List<String> completedLessons) {
    final result = <SkillTreeNode>[];
    var foundCurrent = false;

    for (final module in CourseRepository.modules) {
      final lessons = CourseRepository.getLessonsForModule(module.id);
      for (var i = 0; i < lessons.length; i++) {
        final lesson = lessons[i];
        SkillNodeStatus status;

        if (completedLessons.contains(lesson.id)) {
          status = SkillNodeStatus.completed;
        } else if (!foundCurrent) {
          status = SkillNodeStatus.current;
          foundCurrent = true;
        } else {
          status = SkillNodeStatus.locked;
        }

        result.add(SkillTreeNode(
          lesson: lesson,
          status: status,
          moduleColor: Color(module.color),
          isModuleStart: i == 0,
          moduleTitle: i == 0 ? module.title : null,
        ));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < nodes.length; i++) ...[
          if (nodes[i].isModuleStart) ...[
            const SizedBox(height: 8),
            _ModuleBanner(
              title: nodes[i].moduleTitle!,
              color: nodes[i].moduleColor,
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2),
            const SizedBox(height: 16),
          ],
          _SkillNodeWidget(
            node: nodes[i],
            alignment: i.isEven ? Alignment.centerLeft : Alignment.centerRight,
            offset: i.isEven ? 40.0 : -40.0,
            onTap: () {
              if (nodes[i].status != SkillNodeStatus.locked) {
                onNodeTap(nodes[i].lesson);
              }
            },
          )
              .animate(delay: (i * 40).ms)
              .fadeIn(duration: 350.ms)
              .scale(
                begin: const Offset(0.8, 0.8),
                curve: Curves.elasticOut,
              ),
          if (i < nodes.length - 1)
            _PathConnector(
              fromLeft: i.isEven,
              toLeft: !i.isEven,
              active: nodes[i].status == SkillNodeStatus.completed,
            ),
        ],
        const SizedBox(height: 32),
      ],
    );
  }
}

class _ModuleBanner extends StatelessWidget {
  const _ModuleBanner({required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _SkillNodeWidget extends StatelessWidget {
  const _SkillNodeWidget({
    required this.node,
    required this.alignment,
    required this.offset,
    required this.onTap,
  });

  final SkillTreeNode node;
  final Alignment alignment;
  final double offset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = node.status;
    final size = status == SkillNodeStatus.current ? 72.0 : 64.0;

    Color bgColor;
    Color borderColor;
    Widget icon;

    switch (status) {
      case SkillNodeStatus.completed:
        bgColor = AppColors.success;
        borderColor = AppColors.successDark;
        icon = const Icon(Icons.check, color: Colors.white, size: 28);
      case SkillNodeStatus.current:
        bgColor = node.moduleColor;
        borderColor = node.moduleColor.withValues(alpha: 0.7);
        icon = const Icon(Icons.star, color: Colors.white, size: 30);
      case SkillNodeStatus.locked:
        bgColor = AppColors.skillLocked;
        borderColor = const Color(0xFFBDBDBD);
        icon = Icon(Icons.lock, color: Colors.grey.shade600, size: 24);
      case SkillNodeStatus.chest:
        bgColor = AppColors.accent;
        borderColor = AppColors.nekoOrange;
        icon = const Icon(Icons.redeem, color: Colors.white, size: 28);
    }

    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: Offset(offset, 0),
        child: Column(
          children: [
            GestureDetector(
              onTap: status != SkillNodeStatus.locked ? onTap : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 4),
                  boxShadow: status == SkillNodeStatus.current
                      ? [
                          BoxShadow(
                            color: node.moduleColor.withValues(alpha: 0.5),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: borderColor,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Center(child: icon),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 100,
              child: Text(
                node.lesson.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: status == SkillNodeStatus.current
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: status == SkillNodeStatus.locked
                      ? AppColors.lightTextSecondary
                      : AppColors.lightText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PathConnector extends StatelessWidget {
  const _PathConnector({
    required this.fromLeft,
    required this.toLeft,
    required this.active,
  });

  final bool fromLeft;
  final bool toLeft;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: CustomPaint(
        painter: _PathPainter(
          fromLeft: fromLeft,
          toLeft: toLeft,
          color: active ? AppColors.success : AppColors.skillPath,
        ),
      ),
    );
  }
}

class _PathPainter extends CustomPainter {
  _PathPainter({
    required this.fromLeft,
    required this.toLeft,
    required this.color,
  });

  final bool fromLeft;
  final bool toLeft;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final startX = fromLeft ? size.width * 0.35 : size.width * 0.65;
    final endX = toLeft ? size.width * 0.35 : size.width * 0.65;

    final path = Path()
      ..moveTo(startX, 0)
      ..cubicTo(
        startX,
        size.height * 0.5,
        endX,
        size.height * 0.5,
        endX,
        size.height,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PathPainter oldDelegate) =>
      oldDelegate.color != color;
}
