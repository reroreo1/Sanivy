import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/client_viewmodel.dart';
import '../models/client.dart';

class ClientList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClientViewModel>(
      builder: (context, clientViewModel, child) {
        final clients = clientViewModel.clients;
        
        if (clients.isEmpty) {
          return Center(
            child: Text('No clients yet. Add your first client!'),
          );
        }
        
        return ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) {
            final client = clients[index];
            return ListTile(
              title: Text(client.name),
              subtitle: Text(client.location),
              trailing: Text(client.phoneNumber),
              onTap: () {
                // TODO: Implement client details/editing
              },
            );
          },
        );
      },
    );
  }
}