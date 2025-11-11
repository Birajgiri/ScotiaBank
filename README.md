# Scotiabank Mobile Banking App

A cross-platform mobile banking application built with Flutter, inspired by Scotiabank's mobile banking interface.

## Features

- Welcome screen with Scotiabank branding and current date display
- Account overview displaying Chequing and Savings accounts with balances
- Transaction history with running balance calculations
- Account status indicators
- Secure navigation between screens

## Scotiabank Design Elements

- Color palette: Scotiabank Red (#EC0712), Black, and White
- Brand tagline: "You're richer than you think."
- Custom back navigation with "<" symbol
- Transaction indicators with up/down arrows for debits and credits

## Technical Stack

- Framework: Flutter 3.x
- Language: Dart
- Platforms: Android, iOS, Web, Windows, Linux, macOS
- Data Storage: JSON files

## Project Structure

```
lib/
├── main.dart                          # Application entry point
├── models/
│   ├── account.dart                   # Account data model
│   └── transaction.dart               # Transaction data model
└── screens/
    ├── welcome_screen.dart            # Landing page
    ├── account_list_screen.dart       # Account overview
    └── transaction_detail_screen.dart # Transaction history

assets/
├── data/
│   ├── accounts.json                  # Account data
│   └── transactions.json              # Transaction records
└── images/
    ├── logo.png                       # Scotiabank logo
    └── name.png                       # Scotiabank wordmark
```

## Running the Application

### Web
```bash
flutter run -d chrome
```

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

## Data Format

Accounts and transactions are stored in JSON format in the `assets/data/` directory. The app supports multiple account types with transaction history tracking and running balance calculations.

## Navigation Flow

1. Welcome Screen - Displays Scotiabank branding and current date
2. Account List - Shows available accounts with balances
3. Transaction Details - Displays transaction history with running balances

Back navigation is available at each step using the custom "<" button.
