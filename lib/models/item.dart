import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 0)
class Item extends HiveObject {
  @HiveField(0)
  String category;

  @HiveField(1)
  double price;

  @HiveField(2)
  String referenceName;

  @HiveField(3)
  String name;

  @HiveField(4)
  int stock;

  Item({
    required this.category,
    required this.price,
    required this.referenceName,
    required this.name,
    required this.stock,
  });
}