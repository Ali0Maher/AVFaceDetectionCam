//
//  FaceDetectionManager.swift
//  TestApp
//
//  Created by Ali on 8/23/21.
//

import MLKit
import UIKit
import AVFoundation


/// A manager responsible for face detection measurs
final class FaceDetectionManager {
    
    /// Face detection options
    private let options = FaceDetectorOptions()

    
    /// Setting up the face detection function
    /// - Parameters:
    ///   - sampleBuffer: The camera sample buffer
    ///   - devicePosition: The camera view position Front/Back
    ///   - completionHandler: A handler runs after the face detection finishes that returns whether it did detect face or not
    func setupFaceDetector(sampleBuffer: CMSampleBuffer, devicePosition: AVCaptureDevice.Position, completionHandler: @escaping (Bool,CGRect)-> Void){
        
        options.performanceMode = .accurate
        options.classificationMode = .all
        
        let image = VisionImage(buffer: sampleBuffer)
        
        image.orientation = imageOrientation(
          deviceOrientation: UIDevice.current.orientation,
            cameraPosition: devicePosition)
        
        let faceDetector = FaceDetector.faceDetector(options: options)
        
        faceDetector.process(image) { [weak self] faces, error in
          guard let _ = self else { return }
          guard error == nil, let faces = faces, !faces.isEmpty else {
            completionHandler(false, .zero)
            return
          }
            completionHandler(true,faces.first?.frame ?? .zero)
        }

    }
    
    
    /// A function that return UIImage Orientation
    /// - Parameters:
    ///   - deviceOrientation: The current device orientation
    ///   - cameraPosition: The camera view position Front/Back
    /// - Returns: Return the UIImage orientation
    func imageOrientation(
      deviceOrientation: UIDeviceOrientation,
      cameraPosition: AVCaptureDevice.Position
    ) -> UIImage.Orientation {
      switch deviceOrientation {
      case .portrait:
        return cameraPosition == .front ? .leftMirrored : .right
      case .landscapeLeft:
        return cameraPosition == .front ? .downMirrored : .up
      case .portraitUpsideDown:
        return cameraPosition == .front ? .rightMirrored : .left
      case .landscapeRight:
        return cameraPosition == .front ? .upMirrored : .down
      case .faceDown, .faceUp, .unknown:
        return .up
      @unknown default:
        return .right
      }
    }
}
