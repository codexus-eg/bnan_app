import 'package:bnan_app/core/shared_widget/app_top_feedback/app_top_feedback_type.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class AppTopFeedbackBanner extends StatefulWidget {
  const AppTopFeedbackBanner({
    super.key,
    required this.type,
    required this.title,
    required this.onDismissed,
    this.body,
    this.actionLabel,
    this.onAction,
    this.onTap,
    this.showClose = true,
  });
  final AppTopFeedbackType type;
  final String title;
  final String? body, actionLabel;
  final VoidCallback? onAction, onTap;
  final VoidCallback onDismissed;
  final bool showClose;

  @override
  State<AppTopFeedbackBanner> createState() => AppTopFeedbackBannerState();
}

class AppTopFeedbackBannerState extends State<AppTopFeedbackBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 180),
    )..forward();
  }

  Future<void> dismiss() async {
    if (_closing) return;
    _closing = true;
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors(widget.type);
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween(begin: const Offset(0, -0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: widget.onTap == null
                ? null
                : () {
                    widget.onTap!();
                    dismiss();
                  },
            child: Ink(
              padding: const EdgeInsetsDirectional.fromSTEB(14, 11, 8, 11),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.border),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _Leading(type: widget.type, color: colors.foreground),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _Message(title: widget.title, body: widget.body),
                  ),
                  if (widget.onAction != null)
                    TextButton(
                      onPressed: widget.onAction,
                      child: Text(widget.actionLabel ?? ''),
                    ),
                  if (widget.showClose &&
                      widget.type != AppTopFeedbackType.loading)
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: dismiss,
                      icon: const Icon(Icons.close, size: 19),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _Leading extends StatelessWidget {
  const _Leading({required this.type, required this.color});
  final AppTopFeedbackType type;
  final Color color;

  @override
  Widget build(BuildContext context) => type == AppTopFeedbackType.loading
      ? SizedBox.square(
          dimension: 22,
          child: CircularProgressIndicator(strokeWidth: 2, color: color),
        )
      : Icon(_icon(type), color: color, size: 23);
}

class _Message extends StatelessWidget {
  const _Message({required this.title, this.body});
  final String title;
  final String? body;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: StylesManager.styleBold14(
          context,
        ).copyWith(color: ColorManager.mainColor14),
      ),
      if (body?.trim().isNotEmpty == true)
        Text(
          body!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: StylesManager.styleRegular12(
            context,
          ).copyWith(color: ColorManager.grey6F6F),
        ),
    ],
  );
}

IconData _icon(AppTopFeedbackType type) => switch (type) {
  AppTopFeedbackType.success => Icons.check_circle_outline,
  AppTopFeedbackType.error => Icons.error_outline,
  AppTopFeedbackType.warning => Icons.warning_amber_rounded,
  AppTopFeedbackType.notification => Icons.notifications_none_rounded,
  _ => Icons.info_outline,
};

({Color background, Color border, Color foreground}) _colors(
  AppTopFeedbackType type,
) => switch (type) {
  AppTopFeedbackType.success => (
    background: ColorManager.greenF4,
    border: ColorManager.greenCEE,
    foreground: ColorManager.green23,
  ),
  AppTopFeedbackType.error => (
    background: ColorManager.redFFF,
    border: ColorManager.redEE,
    foreground: ColorManager.redD8,
  ),
  AppTopFeedbackType.warning => (
    background: ColorManager.orangeFFE,
    border: ColorManager.beigeEDC,
    foreground: ColorManager.orangeED,
  ),
  _ => (
    background: ColorManager.greyF8F9,
    border: ColorManager.borderColor,
    foreground: ColorManager.mainColor14,
  ),
};
