import 'package:material_ui/material_ui.dart';
import 'package:mensa_app/data/repositories/repositories.dart';

class MensaDiscoveryViewModel extends ChangeNotifier {
  final DishRepository _dishRepository;

  MensaDiscoveryViewModel({required this._dishRepository});
}
