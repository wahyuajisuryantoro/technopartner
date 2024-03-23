import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:technopartner/models/category_items.dart';
import 'package:technopartner/models/product_items.dart';
import 'package:technopartner/widgets/category_widget.dart';

class MenuScreen extends StatefulWidget {
  final String accessToken;

  const MenuScreen({Key? key, required this.accessToken}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedCategoryIndex = 0;
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    final url = Uri.parse('https://soal.staging.id/api/menu');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'show_all': '1'}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<Category> categories = [];

        for (var category in data['result']['categories']) {
          final List<Menu> menus = [];
          for (var menuData in category['menu']) {
            final Menu menu = Menu(
              name: menuData['name'],
              description: menuData['description'],
              photo: menuData['photo'],
              price: menuData['price'],
            );
            menus.add(menu);
          }
          final Category newCategory = Category(
            categoryName: category['category_name'],
            menuList: menus,
          );
          categories.add(newCategory);
        }

        setState(() {
          _categories = categories;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load menu');
      }
    } catch (e) {
      print('Exception: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch menu data: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        _categories.length,
                        (index) => CategoryItem(
                          title: _categories[index].categoryName,
                          isActive: _selectedCategoryIndex == index,
                          onPressed: () {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        _categories[_selectedCategoryIndex].menuList.length,
                    itemBuilder: (context, index) {
                      final menu =
                          _categories[_selectedCategoryIndex].menuList[index];
                      return ListTile(
                        leading: Image.network(
                          menu.photo, // Gunakan URL foto dari menu
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        title: Text(menu.name),
                        subtitle: Text(menu.description),
                        trailing: Text('\$${menu.price}'),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
