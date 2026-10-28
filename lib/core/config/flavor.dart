/// Build environments. Must match `--flavor` and `config/<flavor>.json`.
enum Flavor {
  dev,
  stg,
  prod;

  static Flavor fromName(String? name) => Flavor.values.firstWhere(
    (flavor) => flavor.name == name,
    orElse: () => Flavor.dev,
  );
}
