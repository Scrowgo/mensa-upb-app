abstract final class Routes {
  static const main = '/main';

  static const mensaDiscovery = '$main/$mensaDiscoveryRelative';
  static const mensaDiscoveryRelative = 'mensaDiscovery';

  static const dishDetail = '$main/$mensaDiscoveryRelative/$dishDetailRelative';
  static const dishDetailRelative = 'dishDetail';

  static const favorites = '$main/$favoritesRelative';
  static const favoritesRelative = 'favorites';
}
