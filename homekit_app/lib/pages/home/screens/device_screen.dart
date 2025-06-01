import 'package:homekit_app/pages/home/services/home_services.dart';
import 'package:homekit_app/pages/account/services/account_services.dart';
import 'package:flutter/material.dart';
import 'package:homekit_app/models/device.dart';
import 'package:homekit_app/constants/global_variables.dart';
import 'package:fl_chart/fl_chart.dart';

class DeviceDetailScreen extends StatefulWidget {
  static const String routeName = '/device-details';
  final DeviceData deviceData;

  const DeviceDetailScreen({super.key, required this.deviceData});

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  final HomeServices homeServices = HomeServices();
  final AccountServices accountServices = AccountServices();
  late DataEntry entry;

  @override
  void initState() {
    super.initState();
    entry = widget.deviceData.data.last;
  }

  List<FlSpot> _getSpots(
    List<DataEntry> entries,
    double? Function(DataEntry) getValue,
  ) {
    return entries.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final value = getValue(entry.value);
      return FlSpot(index, value ?? 0);
    }).toList();
  }

  Widget _buildChart(
      BuildContext context,
      String title,
      List<FlSpot> spots,
      Color color,
      ) {
    final screenWidth = MediaQuery.of(context).size.width;

    final barGroups = spots.map((spot) {
      return BarChartGroupData(
        x: spot.x.toInt(),
        barRods: [
          BarChartRodData(
            toY: spot.y,
            color: color,
            width: 6,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: spots.length * 20,
                child: BarChart(
                  BarChartData(
                    barGroups: barGroups,
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 10,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GlobalVariables.fieldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Device Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoRow("Current Temperature", "${entry.temp}°C"),
              _buildChart(context, "Temperature (°C)", _getSpots(widget.deviceData.data, (e) => e.temp), Colors.orange),
              const Divider(),
              _buildInfoRow("Current Humidity Level", "${entry.hum}%"),
              _buildChart(context, "", _getSpots(widget.deviceData.data, (e) => e.hum), Colors.blue),
              const Divider(),
              _buildInfoRow("Current Gas Level", "${entry.gas}"),
              _buildChart(context, "", _getSpots(widget.deviceData.data, (e) => e.gas?.toDouble()), Colors.green),
              const Divider(),
              _buildInfoRow("Current Pulse Rate", "${(entry.pulse ?? 0) / 10000}"),
              _buildChart(context, "", _getSpots(widget.deviceData.data, (e) => e.pulse?.toDouble()), Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
