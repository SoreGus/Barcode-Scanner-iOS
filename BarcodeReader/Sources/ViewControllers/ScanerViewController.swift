//
//  ScanerViewController.swift
//  BarcodeReader
//
//  Created by Gustavo Luís Soré on 15/09/19.
//  Copyright © 2019 Sore. All rights reserved.
//

import UIKit
import AVFoundation


class ScanerViewController: UIViewController {

    // MARK: Properties
    
    fileprivate let session: AVCaptureSession = AVCaptureSession()
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
    fileprivate let videoOutput = AVCaptureVideoDataOutput()
    
    internal let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
    AVMetadataObject.ObjectType.code39,
    AVMetadataObject.ObjectType.code39Mod43,
    AVMetadataObject.ObjectType.code93,
    AVMetadataObject.ObjectType.code128,
    AVMetadataObject.ObjectType.ean8,
    AVMetadataObject.ObjectType.ean13,
    AVMetadataObject.ObjectType.aztec,
    AVMetadataObject.ObjectType.pdf417,
    AVMetadataObject.ObjectType.qr]
    
    private lazy var camera: AVCaptureDevice? = {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return nil }
        return videoCaptureDevice
    }()
    
    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let camera = camera else{
            return
        }
        let videoInput: AVCaptureDeviceInput?
        
        do {
            videoInput = try AVCaptureDeviceInput(device: camera)
        } catch {
            return
        }
        
        if (session.canAddInput(videoInput!)) {
            session.addInput(videoInput!)
        } else {
            return
        }
        
        //videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
        guard session.canAddOutput(videoOutput) else { return }
        session.addOutput(videoOutput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

            metadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } else {
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        session.startRunning()
    }
        
}

// MARK: AVCaptureMetadataOutputObjectsDelegate
extension ScanerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        for metadata in metadataObjects {
            for barcodeType in supportedCodeTypes {
                if metadata.type == barcodeType {
                    if let resultStirng: String = (metadata as! AVMetadataMachineReadableCodeObject).stringValue {
                        let resulrViewController: ResultViewController
                        resulrViewController = ViewControllerFactory.resultViewController(resultString: resultStirng)
                        resulrViewController.completion = {
                            DispatchQueue.main.async {
                                self.session.startRunning()
                            }
                        }
                        present(resulrViewController, animated: true, completion: nil)
                        session.stopRunning()
                        break
                    }
                }

            }
        }
    }
}

