import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/client.dart';
import '../viewmodels/client_viewmodel.dart';

class AddClientForm extends StatefulWidget {
  @override
  _AddClientFormState createState() => _AddClientFormState();
}

class _AddClientFormState extends State<AddClientForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String location = '';
  String phoneNumber = '';

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
            TextFormField(
              decoration: InputDecoration(labelText: 'Location'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              onSaved: (value) => location = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              onSaved: (value) => phoneNumber = value ?? '',
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Add Client'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final client = Client(
        name: name,
        location: location,
        phoneNumber: phoneNumber,
      );
      
      Provider.of<ClientViewModel>(context, listen: false)
        .addClient(client);
      
      Navigator.of(context).pop();
    }
  }
}