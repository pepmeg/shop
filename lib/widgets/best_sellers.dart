import 'package:flutter/material.dart';
import 'package:shop/products/products.dart';
import '../models/product.dart';
import '../styles/app_styles.dart';

class BestSellers extends StatelessWidget {
  final List<Product> products;

  const BestSellers({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Лучшие продажи',
            style: TextStyle(
              fontSize: 27,
              fontFamily: 'AG',
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (context, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Products(product: product),
                      ),
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: productCardDecoration(),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 10,
                        right: 0,
                        bottom: 40,
                        child: product.imageUrl != null
                            ? Image.network(
                          product.imageUrl!,
                          fit: BoxFit.contain,
                        )
                            : const Icon(Icons.image, size: 50),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}