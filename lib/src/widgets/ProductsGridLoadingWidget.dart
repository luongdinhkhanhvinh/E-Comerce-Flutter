import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductsGridLoadingWidget extends StatelessWidget {
  const ProductsGridLoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        height: 300,
        child: StaggeredGridView.countBuilder(
          primary: false,
          crossAxisCount: 4,
          itemCount: 2,
          itemBuilder: (context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              height: 300,
              width: 275,
              child: Image.asset('assets/img/loading_product.gif', fit: BoxFit.contain),
            );
          },
          staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
          //mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
        ));
  }
}
