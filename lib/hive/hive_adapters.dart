import 'package:hive_ce/hive_ce.dart';
import 'package:mensa_app/core/enums.dart';
import 'package:mensa_app/domain/models.dart';

@GenerateAdapters([
  AdapterSpec<Dish>(),
  AdapterSpec<FavoriteDish>(),
  AdapterSpec<DishTag>(),
  AdapterSpec<DishCategory>(),
  AdapterSpec<Mensa>(),
  AdapterSpec<NutritionInfo>(),
  AdapterSpec<Allergen>(),
  AdapterSpec<Additive>(),
])
part 'hive_adapters.g.dart';
