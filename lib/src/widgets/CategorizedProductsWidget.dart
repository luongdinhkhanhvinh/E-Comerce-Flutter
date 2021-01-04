
import '../../src/controllers/product_controller.dart';
import '../../src/models/category.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/models/product.dart';
import '../../src/widgets/ProductGridItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'CircularLoadingWidget.dart';
import '../../src/widgets/ProductsGridLoadingWidget.dart';

class CategorizedProductsWidget extends StatefulWidget {

  final Animation animationOpacity;
  final Category category;

  const CategorizedProductsWidget (
      {Key key,  this.animationOpacity,  this.category,}) :super(key: key);

  @override
  State<StatefulWidget> createState () => _CategorizedProductsWidget();

}
  class _CategorizedProductsWidget extends StateMVC<CategorizedProductsWidget>{


    ProductController _con;

    _CategorizedProductsWidget() : super(ProductController()) {
      _con = controller;
    }


    @override
    void initState() {
      _con.listenForProductsByCategory(id: widget.category.id);
      super.initState();
    }

  @override
  Widget build(BuildContext context) {

    return _con.categoriesProducts.isEmpty ? ProductsGridLoadingWidget(): FadeTransition(
          opacity: widget.animationOpacity,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: new StaggeredGridView.countBuilder(
              primary: false,
              shrinkWrap: true,
              crossAxisCount: 4,
              itemCount: _con.categoriesProducts.length,
              itemBuilder: (BuildContext context, int index) {
                Product product = _con.categoriesProducts.elementAt(index);
                return ProductGridItemWidget(
                  product: product,
                  heroTag: 'categorized_products_grid',
                );
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
            ),
          ),
    );
  }


}


