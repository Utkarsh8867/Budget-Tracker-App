// ignore_for_file: public_member_api_docs, sort_constructors_first
class ExpenseModel {
  final int? id;
  
  String item;
  int amount;
  bool isIncome;
  DateTime date;

  ExpenseModel({
     this.id,
    required this.item,
    required this.amount,
    required this.isIncome,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item': item,
      'amount': amount,
      'isIncome': isIncome ? 1 : 0, // Storing boolean as integer (1 for true, 0 for false)
      'date': date.toIso8601String(), // Storing DateTime as ISO8601 string
    };
  }

  ExpenseModel copyWith({
    int? id,
    String? item,
    int? amount,
    bool? isIncome,
    DateTime? date,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      item: item ?? this.item,
      amount: amount ?? this.amount,
      isIncome: isIncome ?? this.isIncome,
      date: date ?? this.date,
    );
  }
}


