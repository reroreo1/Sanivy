import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/stock_viewmodel.dart';
import '../models/item.dart';

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StockViewModel>(
      builder: (context, stockViewModel, child) {
        final items = stockViewModel.items;
        
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              title: Text(item.name),
              subtitle: Text('Ref: ${item.referenceName}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Stock: ${item.stock}'),
                  Text('Price: \$${item.price.toStringAsFixed(2)}'),
                ],
              ),
              onTap: () {
                // TODO: Implement item editing
              },
            );
          },
        );
      },
    );
  }
}