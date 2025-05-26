import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';
import '../../viewmodel/qr_scan_viewmodel.dart';

class ScanQRCodeView extends StatefulWidget {
  @override
  _ScanQRCodeViewState createState() => _ScanQRCodeViewState();
}

class _ScanQRCodeViewState extends State<ScanQRCodeView> {
  late QrScanViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Get.put(QrScanViewModel(), tag: 'scan_qr_vm');
  }

  @override
  void dispose() {
    Get.delete<QrScanViewModel>(tag: 'scan_qr_vm');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Scanner
                Obx(() {
                  if (viewModel.cameraController == null) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return MobileScanner(
                    controller: viewModel.cameraController!,
                    onDetect: (barcode, args) {
                      viewModel.processQrResult(barcode, context);
                    },
                  );
                }),

                // Vùng quét
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: 250,
                  height: 250,
                ),

                // Overlay
                Positioned.fill(
                  child: CustomPaint(
                    painter: ScanOverlayPainter(),
                  ),
                ),

                // Trạng thái đang xử lý
                Obx(() => viewModel.isProcessingQR
                    ? Container(
                        color: Colors.black54,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(height: 16),
                              Text(
                                "Đang xử lý...",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      )
                    : SizedBox.shrink()),
              ],
            ),
          ),

          // Hướng dẫn
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  "Đặt mã QR vào trong khung để quét",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "Thông tin danh thiếp sẽ hiển thị sau khi quét thành công",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() => FloatingActionButton(
            onPressed: viewModel.toggleTorch,
            backgroundColor: viewModel.isTorchOn ? Colors.yellow : Colors.blue,
            child: Icon(
              viewModel.isTorchOn ? Icons.flashlight_off : Icons.flashlight_on,
              color: viewModel.isTorchOn ? Colors.black : Colors.white,
            ),
            tooltip: viewModel.isTorchOn ? 'Tắt đèn pin' : 'Bật đèn pin',
          )),
    );
  }
}

// Custom Painter để tạo overlay
class ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scanAreaSize = 250.0;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final left = centerX - (scanAreaSize / 2);
    final top = centerY - (scanAreaSize / 2);
    final right = centerX + (scanAreaSize / 2);
    final bottom = centerY + (scanAreaSize / 2);

    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Vẽ 4 hình chữ nhật xung quanh vùng quét
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, top), paint);
    canvas.drawRect(Rect.fromLTRB(0, bottom, size.width, size.height), paint);
    canvas.drawRect(Rect.fromLTRB(0, top, left, bottom), paint);
    canvas.drawRect(Rect.fromLTRB(right, top, size.width, bottom), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
