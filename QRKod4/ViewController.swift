//
//  ViewController.swift
//  QRKod4
//
//  Created by furkan on 25.07.2023.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Kamera erişimine ve QR kodu yakalama yeteneğine sahip olup olmadığını kontrol edin.
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            print("Kameraya erişilemedi.")
            return
        }

        captureSession = AVCaptureSession()
        captureSession.addInput(input)

        // QR kodlarını yakalamak için metadata çıkışını ayarlayın
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]

        // Kamera görüntüsünü göstermek için önizleme katmanını ayarlayın
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        // Yakalama işlemini başlatın
        captureSession.startRunning()
    }

    // Yakalanan metadatanın (QR kodları dahil) işlenmesini yöneten delegasyon yöntemi
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            // Yakalanan QR kodunu işleyin (örneğin, ekranda gösterin, bir URL açın vb.)
            print("QR Kodu: \(stringValue)")

            // Gerekirse QR kodu yakaladıktan sonra yakalama işlemini durdurun
            captureSession.stopRunning()
        }
    }
}
