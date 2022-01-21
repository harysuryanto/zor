import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerticalSlider extends StatefulWidget {
  final List<Widget> children;

  const VerticalSlider({required this.children, Key? key}) : super(key: key);

  @override
  _VerticalSliderState createState() => _VerticalSliderState();
}

class _VerticalSliderState extends State<VerticalSlider> {
  int _currentIndex = 0;
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = widget.children;
    int childrenCount = children.length;
    const Duration animationDuration = Duration(milliseconds: 100);

    /// Do not show anything if no children
    if (childrenCount == 0) {
      return Container();
    }

    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: animationDuration,
      child: InkWell(
        onTap: () async {
          HapticFeedback.lightImpact();

          setState(() {
            _isVisible = !_isVisible;
          });

          await Future.delayed(animationDuration, () {
            setState(() {
              if (_currentIndex < childrenCount - 1) {
                _currentIndex += 1;
              } else {
                _currentIndex = 0;
              }
            });
          });

          setState(() {
            _isVisible = !_isVisible;
          });
        },
        child: Row(
          children: [
            children[_currentIndex],
            const SizedBox(width: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Do not show indicator if there is only one child
                if (childrenCount > 1)
                  for (int i = 0; i < childrenCount; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Container(
                        width: 4,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              i == _currentIndex ? Colors.grey : Colors.black12,
                        ),
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
