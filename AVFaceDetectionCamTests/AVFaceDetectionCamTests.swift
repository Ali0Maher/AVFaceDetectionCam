//
//  AVFaceDetectionCamTests.swift
//  AVFaceDetectionCamTests
//
//  Created by Ali on 8/24/21.
//

import XCTest
import AVFoundation
@testable import AVFaceDetectionCam

class AVFaceDetectionCamTests: XCTestCase {
    
    let capturedImageExp = XCTestExpectation(description: "capturedImageExp")
    let flipCameraExp = XCTestExpectation(description: "flipCameraExp")
    let cameraBufferExp = XCTestExpectation(description: "cameraBufferExp")
    let view = UIView()

    private lazy var viewModel: AVFaceDetectionCamViewModel = {
        return DefaultAVFaceDetectionCamViewModel(with: self)
    }()

    override func setUpWithError() throws {
        viewModel.cameraManager.delegate = self
    }

    func testCapturedView(){
        viewModel.capturedImage = UIImage(named: "ic_close")
        wait(for: [capturedImageExp], timeout: 2.0)

    }

    func testSettingCamera(){
        viewModel.cameraManager.setupCameraView(view: view)
        XCTAssertNotNil(viewModel.cameraManager.currentVideoInput)
        XCTAssert(viewModel.cameraManager.cameraPosition == .front)
    }

    func testStoppingCameraFeed(){
        viewModel.stopCameraFeed()
        XCTAssert(viewModel.cameraManager.isRunning == false)

    }

    func testResumeCameraFeed(){
        viewModel.startCameraFeed()
        XCTAssert(viewModel.cameraManager.isRunning == true)

    }

    func testFlippingCamera(){
        viewModel.cameraManager.setupCameraView(view: view)
        XCTAssertNotNil(viewModel.cameraManager.currentVideoInput)
        XCTAssert(viewModel.cameraManager.cameraPosition == .front)
        viewModel.flipCamera { [weak self] in
            self?.flipCameraExp.fulfill()

        }
        wait(for: [flipCameraExp], timeout: 2.0)
        XCTAssert(viewModel.cameraManager.cameraPosition == .back)
    }


    func testOutputBuffer(){
        viewModel.cameraManager.setupCameraView(view: view)
        wait(for: [cameraBufferExp], timeout: 5.0)
    }

    func testRemovingInputs(){
        viewModel.cameraManager.setupCameraView(view: view)
        XCTAssertNotNil(viewModel.cameraManager.currentVideoInput)
        viewModel.cameraManager.removeInputMediaType(.video)
        XCTAssertNil(viewModel.cameraManager.currentVideoInput)


    }
}

extension AVFaceDetectionCamTests: AVFaceDetectionCamViewModelDelegate {
    func realTimeFaceDetection(hasFace: Bool,faceFrame: CGRect) {
    }

    func updateImageView() {
        XCTAssert(viewModel.capturedImage == UIImage(named: "ic_close"))
        capturedImageExp.fulfill()
    }


}

extension AVFaceDetectionCamTests: CameraManagerDelegate {

    func outputBufferImage(sampleBuffer: CMSampleBuffer) {
        cameraBufferExp.fulfill()
    }


}

