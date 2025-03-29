import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/stock_viewmodel.dart';
import '../widgets/add_item_form.dart';
import '../models/item.dart';
import '../constants/categories.dart';

class StockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddItemDialog(context),
            tooltip: 'Add New Item',
          ),
        ],
      ),
      body: Consumer<StockViewModel>(
        builder: (context, stockViewModel, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  ),
                  onChanged: (value) {
                    // Implement search functionality
                    stockViewModel.searchItems(value);
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: 2,
                    child: ListView.builder(
                      itemCount: stockViewModel.items.length,
                      itemBuilder: (context, index) {
                        final item = stockViewModel.items[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Text(
                              item.name.substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text('Ref: ${item.referenceName}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Stock: ${item.stock}',
                                style: TextStyle(
                                  color: item.stock < 10 ? Colors.red : null,
                                  fontWeight: item.stock < 10 ? FontWeight.bold : null,
                                ),
                              ),
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          onTap: () => _showEditItemDialog(context, item),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context),
        label: Text('Add Item'),
        icon: Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: AddItemForm(),
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, Item item) {
    String category = item.category;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Item',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: item.name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  item.name = value;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                initialValue: item.referenceName,
                decoration: InputDecoration(
                  labelText: 'Reference',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  item.referenceName = value;
                },
              ),
              SizedBox(height: 8),
              StatefulBuilder(
                builder: (context, setState) {
                  return DropdownButtonFormField<String>(
                    value: category,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: Categories.values.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        category = value ?? Categories.values[0];
                        item.category = category;
                      });
                    },
                  );
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                initialValue: item.price.toString(),
                decoration: InputDecoration(
                  labelText: 'Price',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  item.price = double.tryParse(value) ?? item.price;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                initialValue: item.stock.toString(),
                decoration: InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  item.stock = int.tryParse(value) ?? item.stock;
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<StockViewModel>(context, listen: false)
                          .updateItem(item);
                      Navigator.pop(context);
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
