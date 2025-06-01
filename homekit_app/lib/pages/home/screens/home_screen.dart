import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:homekit_app/pages/home/widgets/device_data_widget.dart';
import 'package:homekit_app/models/device.dart';
import 'package:homekit_app/providers/user_provider.dart';
import 'package:homekit_app/constants/utils.dart';
import 'package:homekit_app/constants/global_variables.dart';
import 'package:homekit_app/pages/home/services/home_services.dart';
import 'package:homekit_app/pages/home/screens/add_device_screen.dart';
import 'package:homekit_app/pages/home/screens/device_screen.dart';
import 'package:homekit_app/pages/home/widgets/weather_widget.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeServices homeServices = HomeServices();
  DeviceData? data;
  String deviceName = "";
  bool isLoading = true;
  List<Widget> cards = [];

  void navigateToAdd() {
    Navigator.pushNamed(context, AddDevice.routeName);
  }

  void navigateToDevice() {
    Navigator.pushNamed(context, DeviceDetailScreen.routeName, arguments: data);
  }

  void addNewCard() {
    setState(() {
      cards.add(
        Card(
          child: Container(
            height: 100,
            alignment: Alignment.center,
            child: Text(
              'Yeni Kart ${cards.length + 1}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    });
  }

  Future<void> fetchDevice() async {
    try {
      final fetched = await homeServices.fetchedDeviceData(context);
      setState(() {
        data = fetched;
        isLoading = false;
      });
    } catch (e) {
      showSnackBar(context, e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDevice();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    deviceName = homeServices.getDeviceName();

    return Scaffold(
      backgroundColor: GlobalVariables.fieldColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: GlobalVariables.backgroundColor,
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await fetchDevice();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 25,
                      vertical: MediaQuery.of(context).size.height / 50),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: user.device == null
                        ? IconButton(
                      onPressed: navigateToAdd,
                      iconSize: MediaQuery.of(context).size.width / 15,
                      icon: const Icon(Icons.add_outlined),
                    )
                        : SizedBox(
                      width: MediaQuery.of(context).size.width / 15,
                      height: MediaQuery.of(context).size.width / 15,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 25,
                      vertical: MediaQuery.of(context).size.height / 50),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome ${user.username}!",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 25,
                    vertical: MediaQuery.of(context).size.height / 50,
                  ),
                  child: Column(
                    children: [
                      // Weather Card
                      Card(
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 6,
                          child: const WeatherWidget(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Device Card
                      if (user.device != null)
                        Row(
                          children: [
                            Card(
                              clipBehavior: Clip.hardEdge,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                height: MediaQuery.of(context).size.height / 6,
                                child: GestureDetector(
                                  onTap: navigateToDevice,
                                  child: DeviceDataWidget(name: deviceName),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
