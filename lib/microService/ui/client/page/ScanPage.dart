import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../module/AudioModule.dart';
import '../common/Scan.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with SingleTickerProviderStateMixin {
  late MobileScannerController _controller;
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _lineAnimation;
  bool _isTorchOn = false;
  bool _isScanning = true;
  // 音效类
  AudioModel audioModel = AudioModel();
  // 扫码类
  Scan scan = Scan();

  var isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(torchEnabled: false);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.blue,
    ).animate(_animationController);

    _lineAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('扫一扫', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(_isTorchOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white),
            onPressed: () {
              _controller.toggleTorch();
              setState(() {
                _isTorchOn = !_isTorchOn;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.cameraswitch_outlined, color: Colors.white),
            onPressed: () {
              _controller.switchCamera();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                Map qr_data = json.decode(barcode.rawValue.toString());
                print('二维码找到！: ${qr_data}');
                // 播放音效
                audioModel.playAudioEffect(Audios.scan);
                // 模态框提示
                EasyLoading.showSuccess(
                  '${"successful".tr()}',
                );
                scan.scanHandlerByType(context, _controller, qr_data);
              }
            },
          ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: ScannerOverlayPainter(
                  colorAnimation: _colorAnimation.value!,
                  linePosition: _lineAnimation.value,
                ),
                child: Container(),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(_isScanning ? Icons.pause : Icons.play_arrow),
                    label: Text(_isScanning ? '暂停' : '开始'),
                    onPressed: () {
                      if (_isScanning) {
                        _controller.stop();
                      } else {
                        _controller.start();
                      }
                      setState(() {
                        _isScanning = !_isScanning;
                      });
                    },
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.image),
                    label: Text('从相册选择'),
                    onPressed: () {
                      // _controller.analyzeImage('path'); // 加载图片
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Color colorAnimation;
  final double linePosition;

  ScannerOverlayPainter(
      {required this.colorAnimation, required this.linePosition});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = colorAnimation
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final double width = size.width * 0.8;
    final double height = size.width * 0.8;
    final double left = (size.width - width) / 2;
    final double top = (size.height - height) / 2;

    final Rect rect = Rect.fromLTWH(left, top, width, height);
    canvas.drawRect(rect, paint);

    final double cornerLength = 20;
    final double cornerWidth = 1;

    final Paint cornerPaint = Paint()
      ..color = colorAnimation
      ..strokeWidth = cornerWidth
      ..style = PaintingStyle.stroke;

    // Draw corners
    canvas.drawLine(
        Offset(left, top), Offset(left + cornerLength, top), cornerPaint);
    canvas.drawLine(
        Offset(left, top), Offset(left, top + cornerLength), cornerPaint);

    canvas.drawLine(Offset(left + width, top),
        Offset(left + width - cornerLength, top), cornerPaint);
    canvas.drawLine(Offset(left + width, top),
        Offset(left + width, top + cornerLength), cornerPaint);

    canvas.drawLine(Offset(left, top + height),
        Offset(left + cornerLength, top + height), cornerPaint);
    canvas.drawLine(Offset(left, top + height),
        Offset(left, top + height - cornerLength), cornerPaint);

    canvas.drawLine(Offset(left + width, top + height),
        Offset(left + width - cornerLength, top + height), cornerPaint);
    canvas.drawLine(Offset(left + width, top + height),
        Offset(left + width, top + height - cornerLength), cornerPaint);

    // Draw moving line
    final Paint linePaint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final double lineTop = top + height * linePosition;
    canvas.drawLine(
        Offset(left, lineTop), Offset(left + width, lineTop), linePaint);

    // Draw dots
    final Paint dotPaint = Paint()
      ..color = Colors.white54
      ..style = PaintingStyle.fill;

    final double dotRadius = 1.0;
    final int dotCount = 10;
    for (int i = 0; i < dotCount; i++) {
      double dotPosition = left + (i / (dotCount - 1)) * width;
      canvas.drawCircle(Offset(dotPosition, lineTop), dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
