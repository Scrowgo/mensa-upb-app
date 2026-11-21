enum Mensa {
  academica('mensa', 'Mensa Academica'),
  forum('mensa-forum', 'Mensa Forum'),
  zm2('mensa-zm2', 'Mensa ZM2'),
  hamm('mensa-hamm', 'Mensa Basilica Hamm'),
  lippstadt('mensa-lippstadt', 'Mensa Atrium Lippstadt'),
  bonaVista('bona-vista', 'Bona Vista'),
  grillCafe('grill-cafe', 'Grill|Café'),
  cafe('cafe', 'Cafete Picknick');

  final String id; // Mensa API venue slug
  final String displayName;

  const Mensa(this.id, this.displayName);

  static Mensa? fromId(String id) =>
      values.where((m) => m.id == id).firstOrNull;
}
