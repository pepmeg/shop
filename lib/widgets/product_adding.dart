import 'package:flutter/material.dart';
import 'package:shop/api/api_service.dart';
import '../models/product.dart';

class ProductListLoader {
  final int itemsPerPage;
  final ScrollController scrollController;
  final Function(List<Product>) onNewProductsLoaded;
  final Function(bool) onLoadingStateChanged;
  final Function(bool) onMoreContentAvailable;
  final bool Function(Product) filterCondition;

  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  List<Product> products = [];

  ProductListLoader({
    required this.itemsPerPage,
    required this.scrollController,
    required this.onNewProductsLoaded,
    required this.onLoadingStateChanged,
    required this.onMoreContentAvailable,
    required this.filterCondition,
  });

  Future<void> initialize() async {
    scrollController.addListener(_scrollListener);
    await loadMoreProducts();
  }

  void dispose() {
    scrollController.removeListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100 &&
        !isLoading && hasMore) {
      loadMoreProducts();
    }
  }

  Future<void> loadMoreProducts() async {
    if (isLoading || !hasMore) return;

    onLoadingStateChanged(true);

    isLoading = true;

    try {
      final List<Product> newProducts = await _fetchProducts();

      if (newProducts.isEmpty) {
        hasMore = false;
      } else {
        products.addAll(newProducts);
        currentPage++;
      }

      onNewProductsLoaded(products);
      onMoreContentAvailable(hasMore);
    } finally {
      onLoadingStateChanged(false);
      isLoading = false;
    }
  }

  Future<List<Product>> _fetchProducts() async {
    final allProducts = await ApiService().fetchProductDetails();
    final filteredProducts = allProducts.where(filterCondition).toList();

    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;

    if (startIndex >= filteredProducts.length) {
      return [];
    }

    if (endIndex > filteredProducts.length) {
      return filteredProducts.sublist(startIndex);
    } else {
      return filteredProducts.sublist(startIndex, endIndex);
    }
  }

  Future<void> refreshProducts() async {
    currentPage = 1;
    hasMore = true;
    products.clear();
    await loadMoreProducts();
  }
}