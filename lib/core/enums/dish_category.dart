enum DishCategory {
  main('Hauptgericht'),
  soup('Suppen & Eintöpfe'),
  side('Beilagen'),
  dessert('Desserts'),
  other('Sonstiges');

  final String displayName;
  const DishCategory(this.displayName);
}
