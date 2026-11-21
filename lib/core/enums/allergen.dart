enum Allergen {
  gluten('1', 'A1', 'Glutenhaltig'),
  eggs('3', 'A3', 'Eier und Eiererzeugnisse'),
  fish('4', 'A4', 'Fisch'),
  peanuts('5', 'A5', 'Erdnüsse und Erdnusserzeugnisse'),
  soy('6', 'A6', 'Soja und Sojaerzeugnisse'),
  milk('7', 'A7', 'Milch und Milcherzeugnisse (einschließlich Lactose)'),
  celery('9', 'A9', 'Sellerie und Sellerieerzeugnisse'),
  mustard('10', 'A10', 'Senf und Senferzeugnisse'),
  sesame('11', 'A11', 'Sesamsamen und Sesamsamenerzeugnisse'),
  sulfites('12', 'A12', 'Schwefeldioxid und Sulfite'),
  wheat('15', 'a', 'Glutenhaltig (Weizen)'),
  oats('17', 'c', 'Glutenhaltig (Hafer)'),
  spelt('18', 'd', 'Glutenhaltig (Dinkel)'),
  barley('19', 'e', 'Glutenhaltig (Gerste)'),
  beef('29', 'R', 'Rind'),
  pork('30', 'S', 'Schwein');

  final String id;
  final String code;
  final String nameDe;

  const Allergen(this.id, this.code, this.nameDe);

  static Allergen? fromId(String id) {
    for (final value in values) {
      if (value.id == id) return value;
    }
    return null;
  }
}
