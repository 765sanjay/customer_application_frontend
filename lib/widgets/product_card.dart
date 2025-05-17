import 'dart:math';

import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  ProductCard(
      {super.key,
      required this.business,
      this.width,
      this.height,
      this.textWidth});

  double? width;
  double? textWidth;
  double? height;
  final Map<String, dynamic> business;

  @override
  Widget build(BuildContext context) {
    double _width = width ?? MediaQuery.of(context).size.width;
    double _textWidth = textWidth ?? _width * 0.6;
    double _height = height ?? min(_width / 2, 200);
    double padding = (_width > 600) ? 30.0 : 15.0;

    final Color cardColor1 = Theme.of(context).colorScheme.primary;
    final Color cardColor2 = Theme.of(context).colorScheme.secondary;
    final Color textColor = Theme.of(context).colorScheme.tertiary;
    final Color starColor = Colors.amber.shade400;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: _height,
          width: _width - 20,
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.white,
              ),
              Positioned(
                right: 10,
                height: _height,
                width: _width * 0.3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Image.network(
                          business['shopimage'] ?? "https://sklyit.xyz/loogo.png",
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...List.generate(
                              5,
                              (int index) => (index + 1 <=
                                      4.2.round())
                                  ? Icon(
                                      Icons.star,
                                      color: starColor,
                                    )
                                  : (index < 4.2)
                                      ? Icon(Icons.star_half, color: starColor)
                                      : Icon(Icons.star_border, color: starColor),
                            ),
                            Text(
                              " ${4.2} (${300})",
                              style: TextStyle(
                                fontSize: 15,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      cardColor1.withOpacity(1),
                      cardColor2.withOpacity(0),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: _textWidth,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(padding, 8.0, 0.0, 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business['shopname'] ?? "",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: textColor,
                        ),
                      ),
                      Flexible(
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 12.0),
                        ),
                      ),
                      Text(
                        business['shopdesc'],
                        style: TextStyle(
                          fontSize: 18,
                          color: textColor.withOpacity(0.90),
                          fontFamily: "Times New Roman",
                        ),
                      ),
                      Flexible(
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 7.0),
                        ),
                      ),
                      Text(
                        business['shopmobile'],
                        style: TextStyle(
                          fontSize: 20,
                          color: textColor,
                          fontFamily: "Times New Roman",
                        ),
                      ),
                      Flexible(
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 5.0),
                        ),
                      ),
                      Text(
                        business['address'] ?? "",
                        style: TextStyle(
                          fontSize: 20,
                          color: textColor,
                          fontFamily: "Times New Roman",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
