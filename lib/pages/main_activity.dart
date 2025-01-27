import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/product.dart';
import '../widgets/new_arrivals.dart';
import '../widgets/shop_by_category.dart';
import '../widgets/best_sellers.dart';
import '../widgets/bottom_menu.dart';
import '../widgets/side_menu.dart';

class MainActivity extends StatefulWidget {
  const MainActivity({Key? key}) : super(key: key);

  @override
  State<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  bool MenuVisible = false;
  late Future<List<Product>> _productDataFuture;
  List<Product>? _newArrivals;
  List<Product>? _bestSellers;

  @override
  void initState() {
    super.initState();
    _productDataFuture = ApiService().fetchProductDetails();
    _loadData();
  }

  Future<void> _loadData() async {
    final products = await _productDataFuture;
    products.shuffle();
    final half = (products.length / 2).floor();
    _newArrivals = products.sublist(0, half);
    _bestSellers = products.sublist(half);

    setState(() {});
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
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                Image.asset(
                  'images/logo.png',
                  width: 189,
                  height: 59,
                  alignment: Alignment.topLeft,
                ),
                const SizedBox(height: 35),
                if (_newArrivals != null)
                  NewArrivals(products: _newArrivals!),
                const SizedBox(height: 20),
                const ShopByCategory(),
                const SizedBox(height: 20),
                if (_bestSellers != null)
                  BestSellers(products: _bestSellers!),
                const SizedBox(height: 50),
              ],
            ),
          ),
          const BottomNavigationBarWidget(),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 30, right: 16),
              child: IconButton(
                icon: Image.asset('images/menu.png', width: 54, height: 54),
                onPressed: _toggleMenu,
              ),
            ),
          ),
          if (MenuVisible) SideMenuWidget(toggleMenu: _toggleMenu),
        ],
      ),
    );
  }
}