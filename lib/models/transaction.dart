class Transaction {
  final String id;
  final String date;
  final String description;
  final String type;
  final double amount;
  final double balance;

  Transaction({
    required this.id,
    required this.date,
    required this.description,
    required this.type,
    required this.amount,
    required this.balance,
  });

  factory Transaction.fromJson(Map<String, dynamic> json, int index, double currentBalance) {
    double amt = (json['amount'] as num).toDouble();
    // Determine type based on amount sign
    String type = amt >= 0 ? 'Credit' : 'Debit';
    
    return Transaction(
      id: 'TXN${index.toString().padLeft(3, '0')}',
      date: json['date'] as String,
      description: json['description'] as String,
      type: type,
      amount: amt.abs(), // Store as positive number
      balance: currentBalance,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'description': description,
      'type': type,
      'amount': amount,
      'balance': balance,
    };
  }
}
