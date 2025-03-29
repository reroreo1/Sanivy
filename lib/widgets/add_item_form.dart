import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../viewmodels/stock_viewmodel.dart';
import '../constants/categories.dart';

class AddItemForm extends StatefulWidget {
  @override
  _AddItemFormState createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String referenceName = '';
  String category = Categories.values[0]; // Default to first category
  double price = 0.0;
  int stock = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              onSaved: (value) => name = value ?? '',
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(labelText: 'Reference'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              onSaved: (value) => referenceName = value ?? '',
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: category,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: Categories.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  category = value ?? Categories.values[0];
                });
              },
              validator: (value) => value == null ? 'Please select a category' : null,
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Price',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                if (double.tryParse(value) == null) return 'Invalid number';
                if (double.parse(value) < 0) return 'Price cannot be negative';
                return null;
              },
              onSaved: (value) => price = double.parse(value ?? '0'),
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                if (int.tryParse(value) == null) return 'Invalid number';
                if (int.parse(value) < 0) return 'Stock cannot be negative';
                return null;
              },
              onSaved: (value) => stock = int.parse(value ?? '0'),
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
                  onPressed: _submitForm,
                  child: Text('Add Item'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final item = Item(
        name: name,
        referenceName: referenceName,
        category: category,
        price: price,
        stock: stock,
      );
      
      Provider.of<StockViewModel>(context, listen: false)
        .addItem(item);
      
      Navigator.pop(context);
    }
  }
}
