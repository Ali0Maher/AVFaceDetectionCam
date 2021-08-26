//
//  AVFaceDetectionCamViewModel.swift
//  TestApp
//
//  Created by Ali on 8/22/21.
//

import UIKit
import AVFoundation


/// CameraViewModel Protocol Functions
protocol AVFaceDetectionCamViewModel {
    var haveCameraAccess: Bool {get}
    var cameraManager: CameraManager {get}
    var takePicture: Bool {get set}
    var faceDetected: Bool {set get}
    var capturedImage: UIImage? {set get}
    func flipCamera(completionHandler: @escaping () -> Void)
    func stopCameraFeed()
    func startCameraFeed()

}
/// CameraViewModel Delegate Functions
protocol AVFaceDetectionCamViewModelDelegate: AnyObject {
    func realTimeFaceDetection(hasFace: Bool,faceFrame: CGRect)
    func updateImageView()

}


final class DefaultAVFaceDetectionCamViewModel: AVFaceDetectionCamViewModel {
    //MARK:- Setting all the variables and constants of the model
    /// The captured Image of camera
    var capturedImage: UIImage? = nil {
        didSet {
            delegate?.updateImageView()
        }
    }
    
    /// A variable that indicats if the user gonna take a picture or not
    var takePicture: Bool = false
    
    
    /// A variable that controls the camera actions
    lazy var cameraManager: CameraManager = {
        return CameraManager(with: self)
    }()

    
    /// A variable that controls the face detection actions
    var faceDetectionManager = FaceDetectionManager()
    
    /// A variable that indicated if there is a face that has been detected in the camera or not
    var faceDetected: Bool = false
    
    
    /// the delegate of the camera view model
    weak var delegate: AVFaceDetectionCamViewModelDelegate?
    
    
    /// An array of face detected values that is used the get the face detection stable state
    var hasFaceValues: [Bool] = [] {
        didSet {
            if hasFaceValues.count == 20 {
                hasFaceValues.removeFirst()
            }
        }
    }
    
    /// initializer of the default view model
    /// - Parameter myDelegate: the view that is going to impleament the delegate
    init(with myDelegate: AVFaceDetectionCamViewModelDelegate) {
        self.delegate = myDelegate
    }
    
    /// A variable that indicates if the user have got the camera permission
    var haveCameraAccess: Bool {
        switch RequestsHelper.cameraAuthorizationStatus() {
        case .granted: return true
        default: return false
        }
    }
    
    
    //MARK:- Functions of the view model
    /// This function is respinsble for flipping the camera view from Front to back or vice versa
    /// - Parameter completionHandler: a completion handler after flipping the camera
    func flipCamera(completionHandler: @escaping () -> Void) {
        cameraManager.toggleCamera {
            completionHandler()
        }
    }
    
    
    /// A function responsible for stopping the camera feed
    func stopCameraFeed() {
        cameraManager.stopCamera()
    }
    /// A function responsible for running the camera feed
    func startCameraFeed() {
        cameraManager.startCamera()
    }

}
//MARK:- CameraManagerDelegate functions
extension DefaultAVFaceDetectionCamViewModel: CameraManagerDelegate {
    func didDetectFace() {
        
    }
    
    /// This function is responsible for returning the camera buffer of frames
    /// - Parameter sampleBuffer: the sample buffer containing the frames of the camera
    func outputBufferImage(sampleBuffer: CMSampleBuffer) {
        faceDetectionManager.setupFaceDetector(sampleBuffer: sampleBuffer, devicePosition: cameraManager.cameraPosition) {[weak self] (hasFace, faceFrame) in
            self?.faceDetected = hasFace
            self?.hasFaceValues.append(hasFace)
            if self?.hasFaceValues.count ?? 0 > 15 {
                self?.delegate?.realTimeFaceDetection(hasFace: self?.hasFaceValues.filter{$0}.count ?? 0 > 12 ? true : false,
                                                      faceFrame: self?.hasFaceValues.filter{$0}.count ?? 0 > 12 ? faceFrame : .zero)
                
            }
        }
        if !takePicture {
            return
        }
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        
        let uiImage = UIImage(ciImage: ciImage)
        
        DispatchQueue.main.async { [weak self] in
            self?.capturedImage = uiImage
            self?.takePicture = false
        }
    }
    
    
}
