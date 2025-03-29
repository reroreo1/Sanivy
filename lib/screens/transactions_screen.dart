import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/client_viewmodel.dart';
import '../models/transaction.dart';
import '../models/client.dart';
import '../widgets/add_transaction_form.dart';

class TransactionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddTransactionDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // TODO: Implement search functionality
              },
            ),
          ),
          Expanded(
            child: Consumer<ClientViewModel>(
              builder: (context, viewModel, child) {
                final allTransactions = _getAllTransactions(viewModel);
                
                if (allTransactions.isEmpty) {
                  return Center(
                    child: Text('No transactions yet'),
                  );
                }

                return ListView.builder(
                  itemCount: allTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = allTransactions[index];
                    final client = _findClientById(viewModel, transaction.clientId);

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text('Client: ${client?.name ?? 'Unknown'}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(transaction.date)}'),
                            Text('Items: ${transaction.itemQuantities.length}'),
                          ],
                        ),
                        trailing: Text(
                          '\$${transaction.totalPrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        onTap: () => _showTransactionDetails(context, transaction, client?.name),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Transaction> _getAllTransactions(ClientViewModel viewModel) {
    final allTransactions = <Transaction>[];
    for (final client in viewModel.clients) {
      allTransactions.addAll(client.salesHistory);
    }
    allTransactions.sort((a, b) => b.date.compareTo(a.date));
    return allTransactions;
  }

  Client? _findClientById(ClientViewModel viewModel, String clientId) {
    try {
      return viewModel.clients.firstWhere(
        (c) => c.key.toString() == clientId,
      );
    } catch (e) {
      return null;
    }
  }

  void _showAddTransactionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SingleChildScrollView(
          child: AddTransactionForm(),
        ),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, Transaction transaction, String? clientName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client: ${clientName ?? 'Unknown'}'),
            Text('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(transaction.date)}'),
            Text('Total: \$${transaction.totalPrice.toStringAsFixed(2)}'),
            SizedBox(height: 8),
            Text('Items:'),
            ...transaction.itemQuantities.entries.map(
              (entry) => Text('${entry.key}: ${entry.value} units'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
