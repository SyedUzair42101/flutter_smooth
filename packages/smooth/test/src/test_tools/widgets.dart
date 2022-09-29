import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class AlwaysBuildBuilder extends StatefulWidget {
  final VoidCallback? onBuild;
  final Widget? child;

  const AlwaysBuildBuilder({super.key, required this.onBuild, this.child});

  @override
  State<AlwaysBuildBuilder> createState() => _AlwaysBuildBuilderState();
}

class _AlwaysBuildBuilderState extends State<AlwaysBuildBuilder> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
    widget.onBuild?.call();
    return widget.child ?? Container();
  }
}

@visibleForTesting
class AlwaysLayoutBuilder extends SingleChildRenderObjectWidget {
  final VoidCallback? onPerformLayout;
  final Object? debugToken;

  const AlwaysLayoutBuilder({
    super.key,
    this.onPerformLayout,
    this.debugToken,
    super.child,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RenderAlwaysLayoutBuilder createRenderObject(BuildContext context) =>
      _RenderAlwaysLayoutBuilder(
        onPerformLayout: onPerformLayout,
        debugToken: debugToken,
      );

  @override
  void updateRenderObject(
      BuildContext context,
      // ignore: library_private_types_in_public_api
      _RenderAlwaysLayoutBuilder renderObject) {
    renderObject
      ..onPerformLayout = onPerformLayout
      ..debugToken = debugToken;
  }
}

class _RenderAlwaysLayoutBuilder extends RenderProxyBox {
  _RenderAlwaysLayoutBuilder({
    required this.onPerformLayout,
    required this.debugToken,
    RenderBox? child,
  }) : super(child);

  VoidCallback? onPerformLayout;
  Object? debugToken;

  @override
  void performLayout() {
    print('$runtimeType.performLayout');

    super.performLayout();
    onPerformLayout?.call();
    SchedulerBinding.instance.addPostFrameCallback((_) => markNeedsLayout());
  }
}
