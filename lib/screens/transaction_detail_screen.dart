import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/account.dart';
import '../models/transaction.dart';

class TransactionDetailScreen extends StatefulWidget {
  final Account account;

  const TransactionDetailScreen({
    super.key,
    required this.account,
  });

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  List<Transaction> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      final String response = await rootBundle.loadString('assets/data/transactions.json');
      final data = json.decode(response);
      final Map<String, dynamic> transactionsData = data['transactions'] as Map<String, dynamic>;
      
      if (transactionsData.containsKey(widget.account.id)) {
        final List<dynamic> transactionsJson = transactionsData[widget.account.id] as List<dynamic>;
        
        // Calculate running balance
        double runningBalance = widget.account.balance;
        List<Transaction> tempTransactions = [];
        
        for (int i = 0; i < transactionsJson.length; i++) {
          final txn = Transaction.fromJson(
            transactionsJson[i] as Map<String, dynamic>,
            i + 1,
            runningBalance,
          );
          tempTransactions.add(txn);
          
          // Update running balance for next transaction
          // If credit, subtract (going backwards in time)
          // If debit, add (going backwards in time)
          if (txn.type == 'Credit') {
            runningBalance -= txn.amount;
          } else {
            runningBalance += txn.amount;
          }
        }
        
        // Reverse the list so latest transactions appear first
        setState(() {
          transactions = tempTransactions.reversed.toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading transactions: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Text(
            '<',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transaction History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFEC0712),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Account Summary Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFEC0712),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.account.accountType,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.account.accountNumber,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Balance',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${widget.account.balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Transactions List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : transactions.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No transactions found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: transactions.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          final bool isCredit = transaction.type == 'Credit';
                          
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isCredit 
                                      ? Colors.green.shade100 
                                      : Colors.red.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isCredit 
                                      ? Icons.arrow_downward 
                                      : Icons.arrow_upward,
                                  color: isCredit 
                                      ? Colors.green.shade700 
                                      : Colors.red.shade700,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                transaction.description,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatDate(transaction.date),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Balance: ${widget.account.currency} ${transaction.balance.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${isCredit ? '+' : '-'}${widget.account.currency} ${transaction.amount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isCredit 
                                          ? Colors.green.shade700 
                                          : Colors.red.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
