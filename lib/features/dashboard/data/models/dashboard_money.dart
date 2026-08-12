import 'package:bnan_app/features/dashboard/data/models/dashboard_parsing.dart';

class DashboardMoney {
  const DashboardMoney({required this.currency, required this.amount});

  final String currency;
  final double amount;

  factory DashboardMoney.fromJson(Map<String, dynamic> json) => DashboardMoney(
    currency: dashboardString(json['currency']),
    amount: dashboardDouble(json['amount']),
  );

  String get amountLabel => amount == amount.roundToDouble()
      ? amount.toInt().toString()
      : amount.toStringAsFixed(2);
}

class DashboardRevenue {
  const DashboardRevenue({this.today = const [], this.month = const []});

  final List<DashboardMoney> today;
  final List<DashboardMoney> month;

  factory DashboardRevenue.fromJson(Object? value) {
    final json = dashboardMap(value);
    List<DashboardMoney> parse(String key) =>
        dashboardList(json[key]).map(DashboardMoney.fromJson).toList();
    return DashboardRevenue(today: parse('today'), month: parse('month'));
  }
}
