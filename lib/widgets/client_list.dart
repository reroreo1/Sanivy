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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                SizedBox(height: 16),
                Text(
                  'No clients yet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 8),
                Text(
                  'Add your first client to get started!',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _showAddClientDialog(context),
                  icon: Icon(Icons.add),
                  label: Text('Add Client'),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          itemCount: clients.length,
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final client = clients[index];
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  child: Text(
                    client.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
                title: Text(
                  client.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(client.location),
                    Text(
                      client.phoneNumber,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () => _showClientOptions(context, client),
                ),
                onTap: () => _showClientDetails(context, client),
              ),
            );
          },
        );
      },
    );
  }

  void _showClientOptions(BuildContext context, Client client) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Client'),
            onTap: () {
              Navigator.pop(context);
              _showEditClientDialog(context, client);
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text('View Transactions'),
            onTap: () {
              Navigator.pop(context);
              _showClientTransactions(context, client);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Delete Client'),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
              _confirmDeleteClient(context, client);
            },
          ),
        ],
      ),
    );
  }

  void _showAddClientDialog(BuildContext context) {
    // Implement the dialog for adding a new client
  }

  void _showEditClientDialog(BuildContext context, Client client) {
    // Implement the dialog for editing an existing client
  }

  void _showClientTransactions(BuildContext context, Client client) {
    // Implement the screen for viewing client transactions
  }

  void _confirmDeleteClient(BuildContext context, Client client) {
    // Implement the confirmation dialog for deleting a client
  }

  void _showClientDetails(BuildContext context, Client client) {
    // Implement the screen for viewing client details
  }
}
