import '../../core/enums/app_enums.dart';

/// User-defined smart savings goal.
class SavingsGoal {
  const SavingsGoal({
    required this.goalId,
    required this.userId,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.monthlyContribution,
    required this.targetDate,
  });

  final String goalId;
  final String userId;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final double monthlyContribution;
  final DateTime targetDate;

  double get progressPercentage => targetAmount <= 0
      ? 0
      : (currentAmount / targetAmount).clamp(0.0, 1.0) * 100;

  double get remainingAmount =>
      (targetAmount - currentAmount).clamp(0.0, double.infinity);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'goalId': goalId,
        'userId': userId,
        'name': name,
        'targetAmount': targetAmount,
        'currentAmount': currentAmount,
        'monthlyContribution': monthlyContribution,
        'targetDate': targetDate.toIso8601String(),
      };

  factory SavingsGoal.fromJson(Map<String, dynamic> json) => SavingsGoal(
        goalId: json['goalId'] as String,
        userId: json['userId'] as String,
        name: json['name'] as String,
        targetAmount: (json['targetAmount'] as num).toDouble(),
        currentAmount: (json['currentAmount'] as num).toDouble(),
        monthlyContribution: (json['monthlyContribution'] as num).toDouble(),
        targetDate: DateTime.parse(json['targetDate'] as String),
      );
}

/// Contribution or withdrawal on a savings goal.
class SavingsTransaction {
  const SavingsTransaction({
    required this.id,
    required this.goalId,
    required this.transactionId,
    required this.amount,
    required this.createdAt,
  });

  final String id;
  final String goalId;
  final String transactionId;
  final double amount;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'goalId': goalId,
        'transactionId': transactionId,
        'amount': amount,
        'createdAt': createdAt.toIso8601String(),
      };

  factory SavingsTransaction.fromJson(Map<String, dynamic> json) =>
      SavingsTransaction(
        id: json['id'] as String,
        goalId: json['goalId'] as String,
        transactionId: json['transactionId'] as String,
        amount: (json['amount'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// Categorized spending breakdown item.
class ExpenseCategory {
  const ExpenseCategory({
    required this.type,
    required this.labelAr,
    required this.labelEn,
    required this.totalSpent,
  });

  final ExpenseCategoryType type;
  final String labelAr;
  final String labelEn;
  final double totalSpent;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': type.name,
        'labelAr': labelAr,
        'labelEn': labelEn,
        'totalSpent': totalSpent,
      };

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) =>
      ExpenseCategory(
        type: ExpenseCategoryType.values.byName(json['type'] as String),
        labelAr: json['labelAr'] as String,
        labelEn: json['labelEn'] as String,
        totalSpent: (json['totalSpent'] as num).toDouble(),
      );
}

/// Rule-based financial health score (0-100).
class FinancialScore {
  const FinancialScore({
    required this.score,
    required this.savingRatio,
    required this.expenseRatio,
    required this.explanationAr,
    required this.calculatedAt,
  });

  final int score;
  final double savingRatio;
  final double expenseRatio;
  final String explanationAr;
  final DateTime calculatedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'score': score,
        'savingRatio': savingRatio,
        'expenseRatio': expenseRatio,
        'explanationAr': explanationAr,
        'calculatedAt': calculatedAt.toIso8601String(),
      };

  factory FinancialScore.fromJson(Map<String, dynamic> json) => FinancialScore(
        score: json['score'] as int,
        savingRatio: (json['savingRatio'] as num).toDouble(),
        expenseRatio: (json['expenseRatio'] as num).toDouble(),
        explanationAr: json['explanationAr'] as String,
        calculatedAt: DateTime.parse(json['calculatedAt'] as String),
      );
}

/// Educational rule-based financial recommendation.
class FinancialRecommendation {
  const FinancialRecommendation({
    required this.id,
    required this.titleAr,
    required this.descriptionAr,
    required this.priority,
  });

  final String id;
  final String titleAr;
  final String descriptionAr;
  final int priority;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'titleAr': titleAr,
        'descriptionAr': descriptionAr,
        'priority': priority,
      };

  factory FinancialRecommendation.fromJson(Map<String, dynamic> json) =>
      FinancialRecommendation(
        id: json['id'] as String,
        titleAr: json['titleAr'] as String,
        descriptionAr: json['descriptionAr'] as String,
        priority: json['priority'] as int,
      );
}
