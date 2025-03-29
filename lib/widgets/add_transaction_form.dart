import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../models/item.dart';
import '../models/client.dart';
import '../viewmodels/stock_viewmodel.dart';
import '../viewmodels/client_viewmodel.dart';

class AddTransactionForm extends StatefulWidget {
  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  Client? selectedClient;
  Map<String, int> itemQuantities = {};
  double totalPrice = 0.0;

  void _updateTotalPrice(BuildContext context) {
    final stockViewModel = Provider.of<StockViewModel>(context, listen: false);
    double total = 0.0;
    
    itemQuantities.forEach((itemId, quantity) {
      final item = stockViewModel.findItemByReference(itemId);
      if (item != null) {
        total += item.price * quantity;
      }
    });

    setState(() {
      totalPrice = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width * 0.8,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'New Transaction',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            Consumer<ClientViewModel>(
              builder: (context, clientViewModel, child) {
                final clients = clientViewModel.clients;
                return DropdownButtonFormField<Client>(
                  value: selectedClient,
                  decoration: InputDecoration(
                    labelText: 'Select Client',
                    border: OutlineInputBorder(),
                  ),
                  items: clients.map((client) {
                    return DropdownMenuItem(
                      value: client,
                      child: Text(client.name),
                    );
                  }).toList(),
                  onChanged: (Client? value) {
                    setState(() {
                      selectedClient = value;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a client' : null,
                );
              },
            ),
            SizedBox(height: 16),
            Consumer<StockViewModel>(
              builder: (context, stockViewModel, child) {
                return Column(
                  children: [
                    Text('Select Items', style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 8),
                    Container(
                      height: 300, // Fixed height for scrollable list
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: stockViewModel.items.length,
                        itemBuilder: (context, index) {
                          final item = stockViewModel.items[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(item.name),
                              subtitle: Text(
                                'Price: \$${item.price.toStringAsFixed(2)} - Available: ${item.stock}',
                              ),
                              trailing: SizedBox(
                                width: 100,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Qty',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    final quantity = int.tryParse(value) ?? 0;
                                    setState(() {
                                      if (quantity > 0) {
                                        itemQuantities[item.referenceName] = quantity;
                                      } else {
                                        itemQuantities.remove(item.referenceName);
                                      }
                                      _updateTotalPrice(context);
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return null;
                                    }
                                    final quantity = int.tryParse(value) ?? 0;
                                    if (quantity < 0) {
                                      return 'Invalid';
                                    }
                                    if (quantity > item.stock) {
                                      return 'Too many';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16),
            Text(
              'Total: \$${totalPrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _submitForm(context),
                  child: Text('Create Transaction'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      if (selectedClient == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a client')),
        );
        return;
      }

      if (itemQuantities.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select at least one item')),
        );
        return;
      }

      try {
        // Ensure we have a valid client key
        if (selectedClient?.key == null) {
          throw Exception('Invalid client selection');
        }

        // Create the transaction
        final transaction = Transaction(
          clientId: selectedClient!.key.toString(),
          itemQuantities: Map<String, int>.from(itemQuantities),
          totalPrice: totalPrice,
        );

        // Update stock quantities
        final stockViewModel = Provider.of<StockViewModel>(context, listen: false);
        for (var entry in itemQuantities.entries) {
          final item = stockViewModel.findItemByReference(entry.key);
          if (item != null) {
            if (item.stock < entry.value) {
              throw Exception('Not enough stock for ${item.name}');
            }
            item.stock -= entry.value;
            await stockViewModel.updateItem(item);
          }
        }

        // Add transaction to client's history
        final clientViewModel = Provider.of<ClientViewModel>(context, listen: false);
        await clientViewModel.addTransaction(selectedClient!.key.toString(), transaction);

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaction created successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}
