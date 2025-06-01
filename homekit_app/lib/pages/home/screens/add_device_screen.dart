import 'dart:io';
import 'package:homekit_app/common/widgets/custom_button.dart';
import 'package:homekit_app/constants/global_variables.dart';
import 'package:homekit_app/common/widgets/custom_textfield.dart';
import 'package:homekit_app/pages/home/services/home_services.dart';
import 'package:flutter/material.dart';
import 'package:homekit_app/constants/utils.dart';

class AddDevice extends StatefulWidget {
  static const String routeName = '/add-device-form';
  const AddDevice({super.key});
  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  final TextEditingController deviceNameController = TextEditingController();
  final TextEditingController deviceWifiController = TextEditingController();
  final TextEditingController devicePassController = TextEditingController();
  final GlobalKey<FormState> _addDeviceFormKey = GlobalKey<FormState>();
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    deviceNameController.dispose();
    deviceWifiController.dispose();
    devicePassController.dispose();
    super.dispose();
  }

  Future<bool> showDeviceConnectingDialog({
    required BuildContext context,
    required Future<bool> Function() onConnect,
  }) async {
    String statusText = "ESP32'ye Wi-Fi bilgileri gönderiliyor...";
    bool connected = false;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        onConnect().then((success) {
          connected = success;
          statusText = success ? "✅ Bağlantı başarılı!" : "❌ Cihaza erişilemedi.";
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(dialogContext).pop(success); // <-- burada bool dönüyor
          });
        });

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                connected
                    ? const Icon(Icons.check_circle, color: Colors.green, size: 50)
                    : const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(statusText, textAlign: TextAlign.center),
              ],
            ),
          );
        });
      },
    ).then((value) => value ?? false); // null dönerse false yap
  }

  void addDevice() async {
    if (!_addDeviceFormKey.currentState!.validate()) return;

    final name = deviceNameController.text.trim();
    final wifi = deviceWifiController.text.trim();
    final pass = devicePassController.text.trim();

    try {
      bool connectionResult = await showDeviceConnectingDialog(
        context: context,
        onConnect: () async {
          // 1. Sunucuya bilgileri gönder
          final success = await homeServices.addDevice(
            context: context,
            name: name,
            wifi: wifi,
            pass: pass,
          );

          if (!success) return false;

          // 2. ESP32'ye bağlanmayı dene
          for (int i = 0; i < 6; i++) {
            await Future.delayed(const Duration(seconds: 10));
            try {
              final res = await HttpClient().getUrl(Uri.parse("http://192.168.111.199/data"));
              final response = await res.close();
              if (response.statusCode == 200) return true;
            } catch (_) {}
          }
          return false;
        },
      );

      if (connectionResult && mounted) {
        showSnackBar(context, "Cihaz başarıyla eklendi!");
        Navigator.of(context).pop();
      } else {
        showSnackBar(context, "Cihaza erişilemedi. Lütfen ağı kontrol edin.");
      }
    } catch (e) {
      showSnackBar(context, "Hata oluştu: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(5),
            color: Colors.lightGreen.shade50),
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.4,
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Device:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.height / 50,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    child: Form(
                      key: _addDeviceFormKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: deviceNameController,
                              filled: false,
                              hintText: 'Device Name',
                            ),
                            const SizedBox(height: 5),
                            CustomTextField(
                              controller: deviceWifiController,
                              filled: false,
                              hintText: 'Wi-Fi Connection Name',
                            ),
                            const SizedBox(height: 5),
                            CustomTextField(
                              controller: devicePassController,
                              filled: false,
                              hintText: 'Wi-Fi Password',
                              maxLines: 1,
                            ),
                            const SizedBox(height: 15),
                            CustomButton(
                              text: 'Add Device',
                              onTap: addDevice,
                              icon: Icons.add_circle_outline_outlined,
                              color: GlobalVariables.buttonBackgroundColor,
                              textColor: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
