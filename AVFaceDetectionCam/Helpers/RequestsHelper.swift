//
//  RequestsHelper.swift
//  TestApp
//
//  Created by Ali on 8/22/21.
//

import UIKit
import AVFoundation

/// CameraAuthorizationStatus Enum
enum CameraAuthorizationStatus {
    case granted
    case notRequested
    case unauthorized
}

typealias RequestCameraPermissionCompletionHandler = (CameraAuthorizationStatus) -> Void

/// A request helper to be user for requesting permissions
struct RequestsHelper {
    
    /// Request permission function
    /// - Parameter completionHandler: A completion that returns the state of the request permission
    static func requestCameraPermission(completionHandler: @escaping RequestCameraPermissionCompletionHandler) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            DispatchQueue.main.async {
                completionHandler(granted ? .granted : .unauthorized)
            }
        }
    }
    
    /// A function that check the authorization status of the camera 
    /// - Returns: returns the current state of the camera authorization status
    static func cameraAuthorizationStatus() -> CameraAuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            return .granted
        case .notDetermined:
            return .notRequested
        default:
            return .unauthorized
        }
    }
    

}
