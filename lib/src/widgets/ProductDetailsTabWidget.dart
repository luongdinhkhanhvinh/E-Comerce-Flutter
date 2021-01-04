import 'package:ecommerce/src/helpers/helper.dart';
import 'package:ecommerce/src/models/route_argument.dart';

import '../../generated/i18n.dart';
import '../../src/controllers/home_controller.dart';
import '../../src/controllers/product_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/helpers/ui_icons.dart';
import '../../src/models/product.dart';
import '../../src/widgets/FlashSalesCarouselWidget.dart';
import 'package:flutter/material.dart';

class ProductDetailsTabWidget extends StatefulWidget {
  Product product;

  ProductDetailsTabWidget({this.product});

  @override
  ProductDetailsTabWidgetState createState() => ProductDetailsTabWidgetState();
}


class ProductDetailsTabWidgetState extends StateMVC<ProductDetailsTabWidget> {
  ProductController _con;
  ProductDetailsTabWidgetState() :super(ProductController()){
    _con = controller;
  }
  @override
  void initState() {
    _con.listenForFeaturedProducts();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /*Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              UiIcons.checked,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              S.of(context).store,
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            widget.product.store.name,
          ),
        ),*/
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              UiIcons.file_2,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              S.of(context).description,
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child:Column(
            children: <Widget>[
              Helper.applyHtml(context, widget.product.description),
              Row(children: <Widget>[
                Text(
                    "Capacity : ",
                ),
                Text(
                    widget.product.capacity
                )
              ],
              ),
              Row(children: <Widget>[
                Text(
                  "Unit : ",
                ),
                Text(
                    widget.product.unit
                )
              ],
              ),
              Row(children: <Widget>[
                Text(
                  "Items in package : ",
                ),
                Text(
                    widget.product.packageItemsCount
                )
              ],
              ),
              Row(children: <Widget>[
                Text(
                  "Available Items : ",
                ),
                Text(
                    widget.product.itemsAvailable
                )
              ],
              ),
              Row(children: <Widget>[
                Text(
                  "Added By : ",
                ),
                Text(
                    widget.product.store.name,
                    overflow: TextOverflow.ellipsis,
                )
              ],
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              UiIcons.box,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              S.of(context).featured_products,
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
        FlashSalesCarouselWidget(
            heroTag: 'product_details_related_products', productsList: _con.featuredProducts),
      ],
    );
  }
}

