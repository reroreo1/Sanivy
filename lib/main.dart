import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sboof/screens/main_screen.dart';
import 'models/item.dart';
import 'models/client.dart';
import 'models/transaction.dart';
import 'viewmodels/stock_viewmodel.dart';
import 'viewmodels/client_viewmodel.dart';
// import 'screens/home_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(ClientAdapter());
  Hive.registerAdapter(TransactionAdapter());
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StockViewModel()..init()),
        ChangeNotifierProvider(create: (_) => ClientViewModel()..init()),
      ],
      child: MaterialApp(
        title: 'Stock Management',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: MainScreen(),
      ),
    );
  }
}
