import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/category.dart';
import '../category/category_notebooks.dart';
import '../category/category_phone.dart';
import '../category/category_tv.dart';

class SideMenuWidget extends StatefulWidget {
  final VoidCallback toggleMenu;

  const SideMenuWidget({Key? key, required this.toggleMenu}) : super(key: key);

  @override
  _SideMenuWidgetState createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ApiService().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: Container(
        width: 250,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(-5, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 40.0, top: 80.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Image.asset('images/close.png', width: 18, height: 18),
                  onPressed: widget.toggleMenu,
                ),
              ),
            ),
            SizedBox(height: 70),
            Expanded(
              child: FutureBuilder<List<Category>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  final categories = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _getCategoryPage(category),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          child: Text(
                            category.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'DM Sans Bold',
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
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