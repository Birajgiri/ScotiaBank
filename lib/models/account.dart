class Account {
  final String id;
  final String accountNumber;
  final String accountType;
  final String accountHolder;
  final double balance;
  final String currency;
  final String status;

  Account({
    required this.id,
    required this.accountNumber,
    required this.accountType,
    required this.accountHolder,
    required this.balance,
    required this.currency,
    required this.status,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    // Generate ID from account type
    String id = json['type'] == 'Chequing' ? 'Chequing' : 'Savings';
    
    return Account(
      id: id,
      accountNumber: json['account_number'] as String,
      accountType: json['type'] as String,
      accountHolder: 'Account Holder', // Default value
      balance: (json['balance'] as num).toDouble(),
      currency: 'CAD', // Default currency
      status: 'Active', // Default status
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountNumber': accountNumber,
      'accountType': accountType,
      'accountHolder': accountHolder,
      'balance': balance,
      'currency': currency,
      'status': status,
    };
  }
}
