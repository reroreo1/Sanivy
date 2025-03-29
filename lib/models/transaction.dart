import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'item.dart';

part 'transaction.g.dart';

@HiveType(typeId: 2)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String clientId;

  @HiveField(2)
  final Map<String, int> itemQuantities; // itemId -> quantity

  @HiveField(3)
  final double totalPrice;

  @HiveField(4)
  final DateTime date;

  Transaction({
    String? id,
    required this.clientId,
    required this.itemQuantities,
    required this.totalPrice,
    DateTime? date,
  }) : this.id = id ?? Uuid().v4(),
       this.date = date ?? DateTime.now();
}