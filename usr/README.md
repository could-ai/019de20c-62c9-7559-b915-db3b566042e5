# Pashu Aushadhi Vikray Kendra App

This is a comprehensive management and point-of-sale (POS) application for the "Pashu Aushadhi Vikray Kendra", developed in accordance with the Livestock Health and Disease Control Program (LHDCP) guidelines.

## Product Overview
The application is designed to help PM-KSKs and Cooperative Societies manage their generic veterinary medicine shops. It provides a simple, offline-first interface to manage inventory, process sales, and track procurement from the Pharmaceuticals & Medical Devices Bureau of India (PMBI).

## Complete Feature List
- **Dashboard**: View overall shop performance, including total sales, total PMBI purchases, and calculated estimated incentives (Operating Margin, Purchase Incentive, and Stock Incentive).
- **Point of Sale (POS)**: A streamlined billing system to quickly add medicines to the cart, check stock limits, and complete sales transactions.
- **Inventory Management**: Track stock levels of Generic and Ethno-Veterinary medicines, with visual alerts for low stock.
- **Purchases Tracking**: Record inward stock and procurement from PMBI, which directly feeds into the monthly purchase incentive calculations.

## Main User Flows
1. **Making a Sale**: Navigate to the POS screen, tap on available medicines to add them to the cart, review the total bill, and tap "Complete Sale" to deduct stock and record the transaction.
2. **Managing Inventory**: Open the Inventory tab to view current stock levels and add new medicine shipments.
3. **Recording Purchases**: Go to the Purchases tab to log new stock arrivals from PMBI, ensuring your 10% purchase incentive is accurately calculated on the Dashboard.

## Tech Stack
- **Framework**: Flutter (Cross-platform support for Android, iOS, Web, and Desktop)
- **State Management**: Built-in `ChangeNotifier` and `ListenableBuilder` for reactive UI updates
- **Architecture**: Model-View framework separating business logic (`models.dart`) from UI components (`screens.dart`).

## Setup and Run Instructions
1. Ensure Flutter is installed on your system.
2. Clone or download the repository.
3. Navigate to the project directory in your terminal.
4. Run `flutter pub get` to fetch any dependencies.
5. Run `flutter run` to launch the app on your preferred device or emulator.

---

## About CouldAI

This application was generated with [CouldAI](https://could.ai), an AI app builder for cross-platform apps that turns prompts into real native iOS, Android, Web, and Desktop apps with autonomous AI agents that architect, build, test, deploy, and iterate production-ready applications.