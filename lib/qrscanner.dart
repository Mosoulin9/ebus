import 'dart:developer';
import 'dart:io';
import 'package:ebus/provider.dart';
import 'package:ebus/screens/company/company_bottom.dart';
import 'package:ebus/services.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Future<void> clear(context, result) async {
    if (result != null) {
      print(result.toString());
      try {
        var res = await http.post(
          Uri.parse('$urla/clear/index.php'),
          body: {
            'id': result!.code.toString(),
            'company':
                Provider.of<UserProvider>(context, listen: false).userFullname
          },
        );
        if (res.statusCode == 200) {
          if (res.body == 'Ticket Cleared!') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                showCloseIcon: true,
                backgroundColor: Colors.transparent,
                content: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.5), // Faint shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: Offset(0, 2), // Offset from the container
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green.withOpacity(0.1)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 15,
                          color: Colors.green,
                        ),
                        Text(
                          res.body,
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    )),
                  ),
                )));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CompanyBottomNav(index: 0)));
          } else if (res.body == 'Failed to clear ticket') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                showCloseIcon: true,
                backgroundColor: Colors.transparent,
                content: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.5), // Faint shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: Offset(0, 2), // Offset from the container
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red.withOpacity(0.1)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cancel,
                          size: 15,
                          color: Colors.red,
                        ),
                        Text(
                          res.body,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    )),
                  ),
                )));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                showCloseIcon: true,
                backgroundColor: Colors.transparent,
                content: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.5), // Faint shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: Offset(0, 2), // Offset from the container
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red.withOpacity(0.1)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cancel,
                          size: 15,
                          color: Colors.red,
                        ),
                        Text(
                          res.body,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    )),
                  ),
                )));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              showCloseIcon: true,
              backgroundColor: Colors.transparent,
              content: Container(
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.5), // Faint shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset: Offset(0, 2), // Offset from the container
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.red.withOpacity(0.1)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cancel,
                        size: 15,
                        color: Colors.red,
                      ),
                      Text(
                        res.body,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  )),
                ),
              )));
        }
      } catch (error) {
        print('Error during HTTP request: $error');
      }
    }
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();

    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 5, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Row(
                                  children: [
                                    Icon(Icons.flashlight_on),
                                    Text(
                                        'Flashlight: ${snapshot.data == true ? 'On' : 'Off'}'),
                                  ],
                                );
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CompanyBottomNav(index: 0)));
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 100.0),
                            child: const Text('Back',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (scanData != null) {
        clear(context, scanData);
      }
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
