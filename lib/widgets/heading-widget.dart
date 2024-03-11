// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:easyfoody/utils/app-constant.dart';
import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  final String headingTitle;
  final String headingSubtitle;
  final VoidCallback onTap;
  final String buttonText;
  const HeadingWidget(
      {super.key,
      required this.headingTitle,
      required this.headingSubtitle,
      required this.buttonText,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConstatnt.categoriesColor,
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headingTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                ),
                Text(
                  headingSubtitle,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                      fontSize: 12.0),
                ),
              ],
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                        color: Color.fromARGB(197, 75, 75, 80), width: 2)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                        color: Color.fromARGB(197, 73, 73, 72)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
