import 'package:flutter/material.dart';

class Medicine {
  final String id;
  final String name;
  final String type; // Generic, Ethno-Veterinary, Allied
  final double mrp;
  int stock;

  Medicine({
    required this.id,
    required this.name,
    required this.type,
    required this.mrp,
    this.stock = 0,
  });
}

class CartItem {
  final Medicine medicine;
  int quantity;

  CartItem({required this.medicine, this.quantity = 1});
  
  double get total => medicine.mrp * quantity;
}

class Transaction {
  final String id;
  final DateTime date;
  final double amount;
  final String type; // 'Sale' or 'Purchase'

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.type,
  });
}

class AppState extends ChangeNotifier {
  List<Medicine> inventory = [
    Medicine(id: '1', name: 'Albendazole Bolus', type: 'Generic', mrp: 50.0, stock: 100),
    Medicine(id: '2', name: 'Oxytetracycline Injection', type: 'Generic', mrp: 120.0, stock: 50),
    Medicine(id: '3', name: 'Ivermectin Injection', type: 'Generic', mrp: 80.0, stock: 30),
    Medicine(id: '4', name: 'Herbal Wound Healing Spray', type: 'Ethno-Veterinary', mrp: 150.0, stock: 20),
    Medicine(id: '5', name: 'Vitamin B-Complex Injection', type: 'Generic', mrp: 45.0, stock: 80),
    Medicine(id: '6', name: 'Calcium Liquid Supplement', type: 'Allied', mrp: 200.0, stock: 40),
  ];

  List<Transaction> transactions = [];

  double get totalSales => transactions.where((t) => t.type == 'Sale').fold(0.0, (sum, t) => sum + t.amount);
  double get totalPurchases => transactions.where((t) => t.type == 'Purchase').fold(0.0, (sum, t) => sum + t.amount);

  // 10% incentive on purchase basis (max 10,000)
  double get purchaseIncentive {
    double incentive = totalPurchases * 0.10;
    return incentive > 10000 ? 10000 : incentive;
  }

  // Stocking mandate (mocked as 85% for example, giving 100% of the 10% stock incentive)
  double get stockIncentive {
    return 10000.0; // Assuming 80-100% range maintained
  }

  void addPurchase(double amount) {
    transactions.add(Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      amount: amount,
      type: 'Purchase',
    ));
    notifyListeners();
  }

  void completeSale(List<CartItem> cart) {
    double total = 0;
    for (var item in cart) {
      total += item.total;
      // reduce stock
      var med = inventory.firstWhere((m) => m.id == item.medicine.id);
      med.stock -= item.quantity;
    }
    transactions.add(Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      amount: total,
      type: 'Sale',
    ));
    notifyListeners();
  }

  void addMedicine(Medicine med) {
    inventory.add(med);
    notifyListeners();
  }
}
