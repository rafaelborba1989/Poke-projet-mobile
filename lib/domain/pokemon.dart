import 'package:floor/floor.dart';

@Entity(tableName: 'Pokemon')
class Pokemon {
  @PrimaryKey(autoGenerate: false)
  final int id;

  @ColumnInfo(name: 'name')
  final String name;

  @ColumnInfo(name: 'baseExperience')
  final int baseExperience;

  @ColumnInfo(name: 'height')
  final int height;

  @ColumnInfo(name: 'isDefault')
  final bool isDefault;

  @ColumnInfo(name: 'order')
  final int order;

  @ColumnInfo(name: 'weight')
  final int weight;

  @ColumnInfo(name: 'url')
  final String url;

  @ColumnInfo(name: 'isCaptured')
  bool isCaptured = false;

  Pokemon({
    required this.id,
    required this.name,
    required this.baseExperience,
    required this.height,
    required this.isDefault,
    required this.order,
    required this.weight,
    required this.isCaptured,
    this.url = '',
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
  return Pokemon(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    baseExperience: json['base_experience'] ?? 0,
    height: json['height'] ?? 0,
    isDefault: json['is_default'] ?? false,
    order: json['order'] ?? 0,
    weight: json['weight'] ?? 0,
    isCaptured: false,
    url: json['url'] ?? '',
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'base_experience': baseExperience,
      'height': height,
      'is_default': isDefault,
      'order': order,
      'weight': weight,
      'isCaptured': isCaptured,
      'url': url,
    };
  }
  @override
  String toString() {
    return 'Pokemon{id: $id, name: $name, baseExperience: $baseExperience, height: $height, isDefault: $isDefault, order: $order, weight: $weight, isCaptured: $isCaptured, url: $url}';
  }

  void capture() {
    this.isCaptured = true;
  }
}