import 'package:flutter/material.dart';
import 'models.dart';

// --- Dashboard Screen ---
class DashboardScreen extends StatelessWidget {
  final AppState appState;
  const DashboardScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pashu Aushadhi Kendra'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Overview',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, 'Total Sales', '₹${appState.totalSales.toStringAsFixed(2)}', Icons.trending_up, Colors.blue)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(context, 'Total Purchases', '₹${appState.totalPurchases.toStringAsFixed(2)}', Icons.shopping_bag, Colors.purple)),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Incentives (Estimated)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildIncentiveCard(context, 'Purchase Incentive (10%)', '₹${appState.purchaseIncentive.toStringAsFixed(2)}', 'Max ₹10,000 based on monthly purchase'),
              const SizedBox(height: 8),
              _buildIncentiveCard(context, 'Stock Incentive (10%)', '₹${appState.stockIncentive.toStringAsFixed(2)}', 'Max ₹10,000 based on product range maintained'),
              const SizedBox(height: 8),
              _buildIncentiveCard(context, 'Operating Margin', '20%', 'Margin on MRP of each drug sold'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[700])),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildIncentiveCard(BuildContext context, String title, String value, String subtitle) {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.tealAccent,
          child: Icon(Icons.monetization_on, color: Colors.teal),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
      ),
    );
  }
}

// --- POS Screen ---
class POSScreen extends StatefulWidget {
  final AppState appState;
  const POSScreen({super.key, required this.appState});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  List<CartItem> cart = [];

  void _addToCart(Medicine med) {
    setState(() {
      var existing = cart.where((item) => item.medicine.id == med.id).toList();
      if (existing.isNotEmpty) {
        if (existing.first.quantity < med.stock) {
          existing.first.quantity++;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough stock!')));
        }
      } else {
        if (med.stock > 0) {
          cart.add(CartItem(medicine: med, quantity: 1));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Out of stock!')));
        }
      }
    });
  }

  void _checkout() {
    if (cart.isEmpty) return;
    widget.appState.completeSale(cart);
    setState(() {
      cart.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sale completed successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    double total = cart.fold(0.0, (sum, item) => sum + item.total);
    bool isWide = MediaQuery.of(context).size.width > 600;

    Widget productGrid = ListenableBuilder(
      listenable: widget.appState,
      builder: (context, child) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWide ? 3 : 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: widget.appState.inventory.length,
          itemBuilder: (context, index) {
            var med = widget.appState.inventory[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _addToCart(med),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('₹${med.mrp.toStringAsFixed(2)}', style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                          Text('Stock: ${med.stock}', style: TextStyle(color: med.stock > 0 ? Colors.grey[700] : Colors.red, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    );

    Widget cartView = Container(
      color: Colors.grey[100],
      width: isWide ? 300 : double.infinity,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Current Bill', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                var item = cart[index];
                return ListTile(
                  title: Text(item.medicine.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('₹${item.medicine.mrp} x ${item.quantity}'),
                  trailing: Text('₹${item.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  leading: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      setState(() {
                        if (item.quantity > 1) {
                          item.quantity--;
                        } else {
                          cart.removeAt(index);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('₹${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: cart.isEmpty ? null : _checkout,
                    child: const Text('Complete Sale', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Point of Sale'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: isWide 
        ? Row(children: [Expanded(child: productGrid), cartView])
        : Column(children: [Expanded(flex: 3, child: productGrid), Expanded(flex: 2, child: cartView)]),
    );
  }
}

// --- Inventory Screen ---
class InventoryScreen extends StatelessWidget {
  final AppState appState;
  const InventoryScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, child) {
          return ListView.builder(
            itemCount: appState.inventory.length,
            itemBuilder: (context, index) {
              var med = appState.inventory[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: med.type == 'Generic' ? Colors.blue[100] : Colors.green[100],
                  child: Icon(med.type == 'Generic' ? Icons.medication : Icons.eco, color: med.type == 'Generic' ? Colors.blue : Colors.green),
                ),
                title: Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${med.type} | MRP: ₹${med.mrp}'),
                trailing: Chip(
                  label: Text('Stock: ${med.stock}'),
                  backgroundColor: med.stock < 10 ? Colors.red[100] : Colors.teal[100],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Mock adding new medicine
          appState.addMedicine(Medicine(
            id: DateTime.now().toString(),
            name: 'New Generic Medicine',
            type: 'Generic',
            mrp: 100.0,
            stock: 50,
          ));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mock medicine added!')));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// --- Purchases Screen ---
class PurchasesScreen extends StatelessWidget {
  final AppState appState;
  const PurchasesScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PMBI Purchases'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, child) {
          var purchases = appState.transactions.where((t) => t.type == 'Purchase').toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Procurement from Pharmaceuticals & Medical Devices Bureau of India (PMBI)',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: purchases.isEmpty 
                  ? const Center(child: Text('No purchases recorded yet.'))
                  : ListView.builder(
                    itemCount: purchases.length,
                    itemBuilder: (context, index) {
                      var p = purchases[index];
                      return ListTile(
                        leading: const Icon(Icons.local_shipping, color: Colors.purple),
                        title: Text('Order #${p.id.substring(p.id.length - 6)}'),
                        subtitle: Text(p.date.toString().substring(0, 16)),
                        trailing: Text('+₹${p.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                      );
                    },
                  ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          appState.addPurchase(5000.0);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mock purchase of ₹5000 recorded!')));
        },
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Record Purchase'),
      ),
    );
  }
}
