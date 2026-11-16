import 'package:hive_ce/hive_ce.dart';
import '../domain/models/favorite_dish/favorite_dish.dart';

@GenerateAdapters([AdapterSpec<FavoriteDish>()])
part 'hive_adapters.g.dart';
