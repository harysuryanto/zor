import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// This widget is to fix issue where transparent Widget (opacity: 0.0) at
/// the TOP of Stack Widget should NOT intercept touch events.
///
/// Source of code: https://stackoverflow.com/questions/57466767/how-to-make-a-gesturedetector-capture-taps-inside-a-stack/57469545#57469545
class CustomStack extends Stack {
  CustomStack({
    Key? key,
    children,
  }) : super(key: key, children: children);

  @override
  CustomRenderStack createRenderObject(BuildContext context) {
    return CustomRenderStack(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.of(context),
      fit: fit,
      // overflow: overflow,
    );
  }
}

class CustomRenderStack extends RenderStack {
  CustomRenderStack({alignment, textDirection, fit, overflow})
      : super(
          alignment: alignment,
          textDirection: textDirection,
          fit: fit,
          // overflow: overflow,
        );

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset? position}) {
    var stackHit = false;

    final children = getChildrenAsList();

    for (var child in children) {
      final StackParentData childParentData =
          child.parentData as StackParentData;

      final childHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position!,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );

      if (childHit) stackHit = true;
    }

    return stackHit;
  }
}
