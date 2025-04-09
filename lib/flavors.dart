enum Flavor {
  dev,
  stg,
  prod,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'dev';
      case Flavor.stg:
        return 'stg';
      case Flavor.prod:
        return 'prod';
    }
  }

}
