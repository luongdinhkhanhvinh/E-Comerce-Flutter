import 'package:flutter/material.dart';

class CardsCarouselLoaderWidget extends StatelessWidget {
  const CardsCarouselLoaderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 320,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 15, offset: Offset(0, 5)),
              ],
            ),
            child: Image.asset(
              'assets/img/loading_card.gif',
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}
