
import '../../src/widgets/BrandsIconsCarouselLoadingWidget.dart';

import '../../src/widgets/ProductsGridLoadingWidget.dart';
import '../../src/widgets/CategoriesIconsCarouselLoadingWidget.dart';
import '../widgets/BrandedProductsWidget.dart';
import '../widgets/DeliveryAddressBottomSheetWidget.dart';
import '../../generated/i18n.dart';
import '../../src/widgets/ShoppingCartButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../src/controllers/home_controller.dart';
import '../../src/helpers/ui_icons.dart';
import '../../src/widgets/BrandsIconsCarouselWidget.dart';
import '../../src/widgets/CategoriesIconsCarouselWidget.dart';
import '../../src/widgets/CategorizedProductsWidget.dart';
import '../../src/widgets/FlashSalesCarouselWidget.dart';
import '../../src/widgets/FlashSalesWidget.dart';
import '../../src/widgets/HomeSliderWidget.dart';
import '../../src/widgets/SearchBarWidget.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../repository/user_repository.dart';

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  const HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> with SingleTickerProviderStateMixin{
  Animation animationOpacity;
  AnimationController animationController;
  HomeController _con;

  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }


  @override
  void initState() {
    _con.listenForTrendingProducts();
    _con.listenForCategories();
    _con.listenForBrands();
    animationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    CurvedAnimation curve = CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)..addListener(() {setState(() {});});
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ValueListenableBuilder(
          valueListenable: settingsRepo.setting,
          builder: (context, value, child) {
            return Text(
              value.appName ?? S.of(context).home,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .merge(TextStyle(letterSpacing: 1.3)),
            );
          },
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
          Container(
            width: 30,
            height: 30,
            margin: EdgeInsetsDirectional.only(start: 0, end: 20),
            child: InkWell(
              borderRadius: BorderRadius.circular(300),
              onTap: () {
                if (currentUser.value.apiToken == null) {
                  _con.requestForCurrentLocation(context);
                } else {
                  var bottomSheetController =
                      widget.parentScaffoldKey.currentState.showBottomSheet(
                    (context) => DeliveryAddressBottomSheetWidget(
                        scaffoldKey: widget.parentScaffoldKey),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                  );
                  bottomSheetController.closed.then((value) {
                    _con.refreshHome();
                  });
                }
              },
              child: Icon(
                UiIcons.map,
                color: Theme.of(context).hintColor,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshHome,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarWidget(
                  onClickFilter: (event) {
                    widget.parentScaffoldKey.currentState.openEndDrawer();
                  },
                ),
              ),
              HomeSliderWidget(),
              FlashSalesHeaderWidget(),
              FlashSalesCarouselWidget(
                  heroTag: 'home_flash_sales',
                  productsList: _con.trendingProducts
              ),
              // Heading (Recommended for you)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    UiIcons.favorites,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).categories,
                    style: Theme.of(context).textTheme.display1,
                  ),
                ),
              ),
              StickyHeader(
                header: _con.categories.isEmpty?CategoriesIconsCarouselLoadingWidget():CategoriesIconsCarouselWidget(
                    heroTag: 'home_categories',
                    categoriesList: _con.categories,
                    onChanged: (id) {
                      setState(() {
                        _con.categorySelected = null;
                        animationController.reverse().then((f) {
                          _con.categorySelected =
                              _con.categories.firstWhere((category) {
                            return category.id == id;
                          });
                          animationController.forward();
                        });
                      });
                    }),
                content: _con.categorySelected == null
                    ? ProductsGridLoadingWidget()
                    : CategorizedProductsWidget(
                        animationOpacity: animationOpacity,
                        category: _con.categorySelected),
              ),
              // Heading (Brands)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    UiIcons.flag,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).brands,
                    style: Theme.of(context).textTheme.display1,
                  ),
                ),
              ),
              StickyHeader(
                header: _con.brands.isEmpty?BrandsIconsCarouselLoadingWidget():BrandsIconsCarouselWidget(
                    heroTag: 'home_brands',
                    brandsList: _con.brands,
                    onChanged: (id) {
                      setState(() {
                        _con.brandSelected = null;
                        animationController.reverse().then((f) {
                          _con.brandSelected = _con.brands.firstWhere((brand) {
                            return brand.id == id;
                          });
                          animationController.forward();
                        });
                      });
                    }),
                content: _con.brandSelected == null
                    ? ProductsGridLoadingWidget()
                    : BrandedProductsWidget(
                        animationOpacity: animationOpacity,
                        brand: _con.brandSelected),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
