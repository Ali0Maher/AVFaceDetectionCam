//
//  Global.swift
//  TestApp
//
//  Created by Ali on 8/24/21.
//

import UIKit

public struct Global {
    public struct Strings {
        static var addingTooltipDesc = NSLocalizedString("Hello, Make sure to face the camera so that te application detect your face, When the capture button turns white color you are free to capture your image. Ok?", comment: "")
        static var proceedWithImage = NSLocalizedString("Would you like to proceed ?", comment: "")
        static var cameraAuth = NSLocalizedString("Camera Authorization", comment: "")
        static var accessCameraPermission = NSLocalizedString("We would like to access the camera of your phone to be able to take your picture", comment: "")
        static var allow = NSLocalizedString("Allow", comment: "")
        static var missingFace = NSLocalizedString("Missing a human face", comment: "")
        static var warning = NSLocalizedString("Warning!", comment: "")
        static var settings = NSLocalizedString("Settings", comment: "")
        static var cancel = NSLocalizedString("Cancel", comment: "")
        static var didNotAllowPermission = NSLocalizedString("you seems like you have rejected the camera permession, please go to settings and reallow the camera permission", comment: "")
    }
}
