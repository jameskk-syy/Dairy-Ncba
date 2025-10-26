import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';
import 'bubble_painter.dart';

class HeaderWidget extends StatelessWidget {
   const HeaderWidget({super.key, required this.pageController, required this.context, required this.onSalesPressed, required this.onColectionsPressed, required this.left, required this.right});
  final PageController pageController;
  final BuildContext context;
  final Function()? onSalesPressed;
  final Function()? onColectionsPressed;
  final Color left;
  final Color right;


  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 300.0,
      height: 45.0,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightColorScheme.primary, width: 2.0),
        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: BubbleIndicatorPainter(pageController: pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
                onPressed: onColectionsPressed,
                child: Text(
                  'Collections',
                  style: TextStyle(
                    color: left,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
                onPressed: onSalesPressed,
                child: Text(
                  'Sales',
                  style: TextStyle(
                    color: right,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
