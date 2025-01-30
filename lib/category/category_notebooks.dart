import 'package:flutter/material.dart';
import 'package:shop/widgets/bottom_menu.dart';
import 'package:shop/widgets/side_menu.dart';
import 'package:shop/widgets/product_card.dart';
import 'package:shop/widgets/product_adding.dart';
import '../models/product.dart';

class CategoryNotebooks extends StatefulWidget {
  final String categoryTitle;

  CategoryNotebooks({Key? key, required this.categoryTitle}) : super(key: key);

  @override
  _CategoryNotebooksState createState() => _CategoryNotebooksState();
}

class _CategoryNotebooksState extends State<CategoryNotebooks> {
  final ScrollController scrollControll = ScrollController();
  late ProductListLoader productListLoad;
  List<Product> _products = [];
  bool MenuVisible = false;

  @override
  void initState() {
    super.initState();

    productListLoad = ProductListLoader(
      itemsPerPage: 6,
      scrollController: scrollControll,
      onNewProductsLoaded: (products) {
        setState(() {
          _products = products;
        });
      },
      onLoadingStateChanged: (loading) {
        setState(() {});
      },
      onMoreContentAvailable: (hasMore) {},
      filterCondition: (product) {
        final lowerCaseTitle = product.title.toLowerCase();
        return lowerCaseTitle.contains("ноутбук") ||
            lowerCaseTitle.contains("ультрабук");
      },
    );
    productListLoad.initialize();
  }

  @override
  void dispose() {
    productListLoad.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      MenuVisible = !MenuVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await productListLoad.refreshProducts();
            },
            child: ListView.builder(
              controller: scrollControll,
              padding: const EdgeInsets.fromLTRB(16.0, 120.0, 16.0, 80.0),
              itemCount: _products.length + (productListLoad.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _products.length) {
                  final product = _products[index];
                  return ProductCard(product: product);
                } else if (productListLoad.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 110,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.white,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 20),
                        Text(
                          widget.categoryTitle,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 27,
                            fontFamily: 'AG'
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 16,
            child: IconButton(
              icon: Image.asset('images/menu.png', width: 54, height: 54),
              onPressed: _toggleMenu,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const BottomNavigationBarWidget(),
          ),
          if (MenuVisible) SideMenuWidget(toggleMenu: _toggleMenu),
        ],
      ),
    );
  }
}