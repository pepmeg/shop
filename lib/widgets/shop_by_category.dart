import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/category.dart';
import '../category/category_notebooks.dart';
import '../category/category_phone.dart';
import '../category/category_tv.dart';
import '../styles/app_styles.dart';

class ShopByCategory extends StatelessWidget {
  const ShopByCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Категории',
            style: TextStyle(
              fontSize: 27,
              fontFamily: 'AG',
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 10),
        FutureBuilder<List<Category>>(
          future: ApiService().fetchCategories(),
          builder: (context, snapshot) {
            final categories = snapshot.data ?? [];
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return _buildCategoryTile(
                  context,
                  category.imageUrl,
                  _getCategoryPage(category),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryTile(
      BuildContext context, String imageUrl, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              decoration: productCardDecoration(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Image.network(imageUrl, width: 90, height: 60),
          ),
        ],
      ),
    );
  }

  Widget _getCategoryPage(Category category) {
    switch (category.categoryId) {
      case 3972:
        return CategoryNotebooks(categoryTitle: category.title);
      case 3973:
        return CategoryPhone(categoryTitle: category.title);
      case 3974:
        return CategoryTV(categoryTitle: category.title);
      default:
        return Container();
    }
  }
}