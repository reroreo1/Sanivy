import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/item.dart';

class StockViewModel extends ChangeNotifier {
  late Box<Item> _itemsBox;
  List<Item> _items = [];

  List<Item> get items => _items;

  Future<void> init() async {
    _itemsBox = await Hive.openBox<Item>('items');
    _loadItems();
  }

  void _loadItems() {
    _items = _itemsBox.values.toList();
    notifyListeners();
  }

  Future<void> addItem(Item item) async {
    await _itemsBox.put(item.referenceName, item);
    _loadItems();
  }

  Future<void> updateItem(Item item) async {
    await _itemsBox.put(item.referenceName, item);
    _loadItems();
  }

  Item? findItemByReference(String reference) {
    return _itemsBox.get(reference);
  }

  List<Item> searchItems(String query) {
    return _items.where((item) =>
      item.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}