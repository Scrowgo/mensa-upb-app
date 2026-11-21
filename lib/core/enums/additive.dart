enum Additive {
  colouring('1', '1', 'mit Farbstoff(en)'),
  preservative('2', '2', 'mit Konservierungsstoff(en)'),
  antioxidant('3', '3', 'mit Antioxidationsmittel'),
  flavourEnhancer('4', '4', 'mit Geschmacksverstärker(n)'),
  sweetener('9', '9', 'mit Süßungsmittel(n)'),
  caffeinated('13', '13', 'koffeinhaltig'),
  milkProtein('15', '15', 'Milcheiweiß');

  final String id;
  final String code;
  final String nameDe;

  const Additive(this.id, this.code, this.nameDe);

  static Additive? fromId(String id) {
    for (final value in values) {
      if (value.id == id) return value;
    }
    return null;
  }
}
