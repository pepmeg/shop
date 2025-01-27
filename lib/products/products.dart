import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:shop/widgets/bottom_menu.dart';

class Products extends StatefulWidget {
  final Product product;
  Products({Key? key, required this.product}) : super(key: key);

  @override
  _Product1State createState() => _Product1State();
}

class _Product1State extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 343.0,
                    height: 323.0,
                    margin: const EdgeInsets.only(left: 14.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.product.imageUrl ?? 'https://i.ibb.co/4dr0v9x/no-image.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 26.0, right: 16),
                    child: Text(
                      widget.product.title,
                      style: const TextStyle(
                          fontSize: 27.0,
                          color: Colors.black,
                          fontFamily: 'AG',),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
                    child: Text(
                      widget.product.productDescription,
                      style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                          fontFamily: 'DM Sans Bold',),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 24.0, right: 16),
                    child: Text(
                      '${widget.product.price} руб.',
                      style: const TextStyle(
                          fontSize: 27.0,
                          color: Colors.black,
                          fontFamily: 'AG',),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          const BottomNavigationBarWidget(),
        ],
      ),
    );
  }
}