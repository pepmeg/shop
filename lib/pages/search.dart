import 'package:flutter/material.dart';
import 'package:shop/widgets/bottom_menu.dart';
import 'package:shop/widgets/side_menu.dart';
import 'package:shop/widgets/product_card.dart';
import 'package:shop/widgets/product_adding.dart';
import '../models/product.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController scrollControll = ScrollController();
  late ProductListLoader productListLoad;
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool MenuVisible = false;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    productListLoad = ProductListLoader(
      itemsPerPage: 6,
      scrollController: scrollControll,
      onNewProductsLoaded: (products) {
        setState(() {
          _products = products;
          _filteredProducts = _filterProducts(searchQuery);
        });
      },
      onLoadingStateChanged: (loading) {
        setState(() {});
      },
      onMoreContentAvailable: (hasMore) {},
      filterCondition: (product) => true,
    );
    productListLoad.initialize();
  }

  List<Product> _filterProducts(String query) {
    if (query.isEmpty) {
      return _products;
    }
    return _products.where((product) => product.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      _filteredProducts = _filterProducts(query);
    });
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await productListLoad.refreshProducts();
              },
              child: ListView.builder(
                controller: scrollControll,
                padding: const EdgeInsets.fromLTRB(16.0, 180.0, 16.0, 80.0),
                itemCount: _filteredProducts.length + (productListLoad.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _filteredProducts.length) {
                    final product = _filteredProducts[index];
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.white,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 20),
                          const Text(
                            "Поиск",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 27,
                              fontFamily: 'AG'
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        onChanged: _updateSearchQuery,
                        decoration: InputDecoration(
                          hintText: "Поиск",
                          prefixIcon: const Icon(Icons.search, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                        ),
                        style: const TextStyle(fontSize: 18),
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
      ),
    );
  }
}