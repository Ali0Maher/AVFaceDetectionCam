//
//  CameraManager.swift
//  TestApp
//
//  Created by Ali on 8/21/21.
//

import UIKit
import AVFoundation

//MARK:- Camera Manager delegate functions
protocol CameraManagerDelegate: AnyObject {
    func outputBufferImage(sampleBuffer: CMSampleBuffer)
}

final class CameraManager: NSObject {
    
    //MARK:- Setting all the camera variables and constants
    
    // Capture session object
    internal let captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.automaticallyConfiguresCaptureDeviceForWideColor = true
        return session
    }()
    
    /// Output of the camera viwe
    let dataOutput = AVCaptureVideoDataOutput()
    var cameraView = UIView()
    
    
    /// Current camera position Front or Back
    var cameraPosition: AVCaptureDevice.Position {
        return currentVideoInput?.device.position ?? .unspecified
    }
    
    
    /// A thread to be user for the camera use
    internal let sessionQueue = DispatchQueue(label: "Capture Session Queue", qos: .userInteractive)
    
    internal let videoStabilizationMode = AVCaptureVideoStabilizationMode.standard
    var previewLayer = AVCaptureVideoPreviewLayer()

    weak var delegate: CameraManagerDelegate?
    
    init(with delegate: CameraManagerDelegate) {
        self.delegate = delegate
    }
    
    
    /// Setuping the camera views and starting it
    /// - Parameter view: The view that the camera would be assigned to.
    func setupCameraView(view: UIView) {
        cameraView = view
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        addVideoInput(position: .front)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        captureSession.addOutput(dataOutput)
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.startRunning()
        
        
    }
    
    // Current Video input device
    var currentVideoInput: AVCaptureDeviceInput? {
        return captureSession.inputs.first {
            if let deviceInput = $0 as? AVCaptureDeviceInput, deviceInput.device.hasMediaType(.video) {
                return true
            } else {
                return false
            }
        } as? AVCaptureDeviceInput
    }
    
    
    // Add Video input
    func addVideoInput(position: AVCaptureDevice.Position = .back) {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) {
            addInputDevice(device)
        }
    }
    
    // Add Input
    func addInputDevice(_ device: AVCaptureDevice) {
        if let input = try? AVCaptureDeviceInput(device: device) {
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        }
    }
    
    
    /// is the camera still running
    public var isRunning: Bool {
        captureSession.isRunning
    }
    
    
    /// Toggle the camera view to front or back
    /// - Parameter handler: A handelr runs after the camera has been switched
    func toggleCamera(completionHandler handler: @escaping () -> Void) {
        
        sessionQueue.async {
            self.captureSession.beginConfiguration()
            
            let currentVideoInput = self.currentVideoInput
            
            self.removeInputMediaType(.video)
            
            switch currentVideoInput?.device.position {
            case .front, .unspecified:
                self.addVideoInput(position: .back)
            case .back:
                self.addVideoInput(position: .front)
            default:
                break
            }
            
            // On Photo, Setting the video orientation, mirroring, video stabilization
            if let connection = self.dataOutput.connections.first {
                if connection.isVideoOrientationSupported {
                    connection.videoOrientation = .portrait
                }
                
                if connection.isVideoStabilizationSupported {
                    connection.preferredVideoStabilizationMode = self.videoStabilizationMode
                }
                
                if connection.isVideoMirroringSupported {
                    if let deviceInput = connection.inputPorts.first?.input as? AVCaptureDeviceInput {
                        connection.automaticallyAdjustsVideoMirroring = false
                        connection.isVideoMirrored = deviceInput.device.position == .front
                    } else {
                        connection.automaticallyAdjustsVideoMirroring = true
                    }
                }
            }
            
            self.captureSession.commitConfiguration()
            
            OperationQueue.main.addOperation {
                handler()
            }
        }
    }
    
    // Remove Input
    func removeInputMediaType(_ mediaType: AVMediaType?) {
        let inputs = captureSession.inputs
        for input in inputs {
            if let deviceInput = input as? AVCaptureDeviceInput {
                if let mediaType = mediaType, deviceInput.device.hasMediaType(mediaType) {
                    captureSession.removeInput(deviceInput)
                } else if mediaType == nil {
                    captureSession.removeInput(deviceInput)
                }
            }
        }
    }
    
    // Add Output type to Photo
    func addPhotoOutput(connection: AVCaptureConnection) {
        
        if connection.isVideoOrientationSupported {
            connection.videoOrientation = .portrait
        }
        
        if connection.isVideoStabilizationSupported {
            connection.preferredVideoStabilizationMode = videoStabilizationMode
        }
        
        if connection.isVideoMirroringSupported {
            if let deviceInput = connection.inputPorts.first?.input as? AVCaptureDeviceInput {
                connection.automaticallyAdjustsVideoMirroring = false
                connection.isVideoMirrored = deviceInput.device.position == .front
            } else {
                connection.automaticallyAdjustsVideoMirroring = true
            }
        }
        
        connection.automaticallyAdjustsVideoMirroring = true
        
        
    }
    
    /// Stopping the camera from running
    func stopCamera() {
        if isRunning {
            captureSession.stopRunning()
        }
    }
    /// Start camera view
    func startCamera(){
        if !isRunning {
            captureSession.startRunning()
        }
    }
}

//MARK:- AVCaptureVideoDataOutputSampleBufferDelegate functions
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        addPhotoOutput(connection: connection)
        delegate?.outputBufferImage(sampleBuffer: sampleBuffer)
        
    }
}
