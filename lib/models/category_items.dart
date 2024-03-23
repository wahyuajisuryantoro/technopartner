class Category {
  final String categoryName;
  final List<Menu> menuList;

  Category({required this.categoryName, required this.menuList});
}

class Menu {
  final String name;
  final String description;
  final String photo;
  final int price;

  Menu({
    required this.name,
    required this.description,
    required this.photo,
    required this.price,
  });
}
