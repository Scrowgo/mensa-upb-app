import 'package:flutter_test/flutter_test.dart';
import 'package:mensa_app/models/dish.dart';
import 'package:mensa_app/models/favorite_dish.dart';

void main() {
  group('Dish Category Mapping & Priority Tests', () {
    test('Correctly maps categories according to website rules', () {
      final hauptgerichtVegan = Dish(name: 'Vegan 1 Dish', studentPrice: 3.5, category: 'Vegan 1');
      final hauptgerichtFleisch = Dish(name: 'Schnitzel', studentPrice: 4.5, category: 'Fleisch/Fisch');
      final hauptgerichtSnack = Dish(name: 'Currywurst', studentPrice: 4.0, category: 'Zwischenverpflegung');
      final suppeEintopf = Dish(name: 'Linsensuppe', studentPrice: 2.3, category: 'Stamm Eintopf 1 f 2,30€');
      final suppe = Dish(name: 'Tomatensuppe', studentPrice: 1.5, category: 'Tagessuppe');
      final beilageSalat = Dish(name: 'Salat', studentPrice: 0.8, category: 'Stamm Beilagensalat 0,80€');
      final beilageReis = Dish(name: 'Reis', studentPrice: 0.8, category: 'Stamm Sättigungbeil 0,80€');
      final beilageGemuese = Dish(name: 'Erbsen', studentPrice: 0.8, category: 'Stamm Gemüsebeil. 1 0,80€');
      final dessertStandard = Dish(name: 'Pudding', studentPrice: 0.8, category: 'Stamm Dessert 0,80€');
      final dessertVegan = Dish(name: 'Cookiemousse', studentPrice: 1.5, category: 'Counter Dessert Vegan');

      expect(hauptgerichtVegan.displayCategory, 'hauptgericht');
      expect(hauptgerichtFleisch.displayCategory, 'hauptgericht');
      expect(hauptgerichtSnack.displayCategory, 'hauptgericht');
      expect(suppeEintopf.displayCategory, 'suppe');
      expect(suppe.displayCategory, 'suppe');
      expect(beilageSalat.displayCategory, 'beilage');
      expect(beilageReis.displayCategory, 'beilage');
      expect(beilageGemuese.displayCategory, 'beilage');
      expect(dessertStandard.displayCategory, 'dessert');
      expect(dessertVegan.displayCategory, 'dessert');
    });

    test('Ensures exact 4-step sorting order: 1. Hauptgerichte, 2. Suppen & Eintöpfe, 3. Beilagen, 4. Desserts', () {
      final dishes = [
        Dish(name: 'Cookiemousse', studentPrice: 1.5, category: 'Counter Dessert Vegan'),
        Dish(name: 'Salat', studentPrice: 0.8, category: 'Stamm Beilagensalat 0,80€'),
        Dish(name: 'Linsensuppe', studentPrice: 2.3, category: 'Stamm Eintopf 1 f 2,30€'),
        Dish(name: 'Vegan 1 Dish', studentPrice: 3.5, category: 'Vegan 1'),
      ];

      dishes.sort((a, b) => a.categoryPriority.compareTo(b.categoryPriority));

      expect(dishes[0].displayCategory, 'hauptgericht');
      expect(dishes[0].categoryPriority, 1);
      expect(dishes[1].displayCategory, 'suppe');
      expect(dishes[1].categoryPriority, 2);
      expect(dishes[2].displayCategory, 'beilage');
      expect(dishes[2].categoryPriority, 3);
      expect(dishes[3].displayCategory, 'dessert');
      expect(dishes[3].categoryPriority, 4);
    });

    test('FavoriteDish mirrors Dish displayCategory logic', () {
      final favEintopf = FavoriteDish(
        dishId: 1,
        name: 'Eintopf',
        imageUrl: '',
        category: 'Stamm Eintopf',
        studentPrice: 2.3,
        mensaId: 'mensa',
        mensaName: 'Mensa Academica',
        favoritedDate: DateTime.now(),
        tags: [],
      );

      final favDessert = FavoriteDish(
        dishId: 2,
        name: 'Dessert',
        imageUrl: '',
        category: 'Counter Dessert Vegan',
        studentPrice: 1.5,
        mensaId: 'mensa',
        mensaName: 'Mensa Academica',
        favoritedDate: DateTime.now(),
        tags: [],
      );

      expect(favEintopf.displayCategory, 'suppe');
      expect(favEintopf.categoryPriority, 2);
      expect(favDessert.displayCategory, 'dessert');
      expect(favDessert.categoryPriority, 4);
    });

    test('Mensa venues list includes all key locations', () {
      final venueIds = Mensa.all.map((m) => m.id).toList();
      expect(venueIds.contains('mensa'), isTrue);
      expect(venueIds.contains('mensa-forum'), isTrue);
      expect(venueIds.contains('mensa-zm2'), isTrue);
      expect(venueIds.contains('mensa-hamm'), isTrue);
      expect(venueIds.contains('mensa-lippstadt'), isTrue);
    });
  });
}
