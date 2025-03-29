import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/client.dart';
import '../models/transaction.dart';

class ClientViewModel extends ChangeNotifier {
  late Box<Client> _clientsBox;
  List<Client> _clients = [];

  List<Client> get clients => _clients;

  Future<void> init() async {
    _clientsBox = await Hive.openBox<Client>('clients');
    _loadClients();
  }

  void _loadClients() {
    _clients = _clientsBox.values.toList();
    notifyListeners();
  }

  Future<void> addClient(Client client) async {
    await _clientsBox.add(client);
    _loadClients();
  }

  Future<void> updateClient(Client client) async {
    await client.save();
    _loadClients();
  }

  List<Client> searchClients(String query) {
    return _clients.where((client) =>
      client.name.toLowerCase().contains(query.toLowerCase())).toList();
  }

  Future<void> addTransaction(String clientId, Transaction transaction) async {
    var client = _clientsBox.values.firstWhere((c) => c.key == clientId);
    client.salesHistory.add(transaction);
    await updateClient(client);
  }
}