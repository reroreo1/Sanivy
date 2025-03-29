import 'package:hive/hive.dart';
import 'transaction.dart';

part 'client.g.dart';

@HiveType(typeId: 1)
class Client extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<Transaction> salesHistory;

  @HiveField(2)
  String location;

  @HiveField(3)
  String phoneNumber;

  Client({
    required this.name,
    required this.location,
    required this.phoneNumber,
    this.salesHistory = const [],
  });
}