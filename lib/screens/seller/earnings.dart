import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'dashboard.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<EarningsData> earnings = [
      EarningsData('Jan', 1200),
      EarningsData('Feb', 1500),
      EarningsData('Mar', 1800),
      EarningsData('Apr', 2000),
      EarningsData('May', 1700),
      EarningsData('Jun', 1900),
    ];

    final double totalEarnings = earnings.fold(0, (sum, e) => sum + e.amount);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SellerDashboard(totalEarnings: totalEarnings),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings Overview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          title: const ChartTitle(text: 'Monthly Earnings'),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
          ColumnSeries<EarningsData, String>(
              dataSource: earnings,
              xValueMapper: (EarningsData data, _) => data.month,
              yValueMapper: (EarningsData data, _) => data.amount,
              name: 'Earnings',
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            )
          ],
        ),
      ),
    );
  }
}

class EarningsData {
  final String month;
  final double amount;

  EarningsData(this.month, this.amount);
}
