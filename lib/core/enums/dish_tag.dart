enum DishTag {
  meat("Fleisch"),
  fish("Fisch"),
  vegetarian("Vegetarisch"),
  vegan("Vegan"),
  special("Aktion");

  final String displayName;
  const DishTag(this.displayName);
}
