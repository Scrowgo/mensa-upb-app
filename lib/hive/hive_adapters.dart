import 'package:hive_ce/hive_ce.dart';
import '../models/favorite_dish.dart';

@GenerateAdapters([AdapterSpec<FavoriteDish>()])
part 'hive_adapters.g.dart';
