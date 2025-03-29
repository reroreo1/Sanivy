import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/stock_viewmodel.dart';
import '../viewmodels/client_viewmodel.dart';
import '../widgets/item_list.dart';
import '../widgets/client_list.dart';
import '../widgets/add_item_form.dart';
import '../widgets/add_client_form.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Management'),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => _showAddItemDialog(context),
                      child: Text('Add New Item'),
                    ),
                    Expanded(child: ItemList()),
                  ],
                ),
              ),
              VerticalDivider(),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => _showAddClientDialog(context),
                      child: Text('Add New Client'),
                    ),
                    Expanded(child: ClientList()),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: AddItemForm(),
      ),
    );
  }

  void _showAddClientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: AddClientForm(),
      ),
    );
  }
}