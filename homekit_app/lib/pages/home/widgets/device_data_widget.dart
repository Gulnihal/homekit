import 'package:flutter/material.dart';
import 'package:homekit_app/constants/global_variables.dart';

class DeviceDataWidget extends StatelessWidget {
  final String name;

  const DeviceDataWidget({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 20, 35, 20),
      decoration: BoxDecoration(
        gradient: GlobalVariables.deviceWidgetBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row (
        children: [
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(IconData(0xe37c, fontFamily: 'MaterialIcons',)),
              const SizedBox(width: 10),
              const SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                  "online mi bu",
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width / 35),
                  maxLines: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}