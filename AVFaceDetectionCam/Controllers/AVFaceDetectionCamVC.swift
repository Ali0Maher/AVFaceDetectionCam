//
//  AVFaceDetectionCamVC.swift
//  TestApp
//
//  Created by Ali on 8/21/21.
//

import UIKit
import AVFoundation


/// Protocol resposible for returning the user UIImage
public protocol AVFaceDetectionCamVCDelegate: AnyObject {
    
    /// A function that returns the user final image
    /// - Parameter image: The returned UIImage of user
    func didReturnUserFaceImage(image: UIImage?)
}

open class AVFaceDetectionCamVC: UIViewController {

    
    //MARK:- Setting the variables and constants
    ///Request Custom View
    let requestAuthView = RequestCameraPermissionView()
    ///Camera Cusom View
    var cameraView: CameraUIView = CameraUIView()
    
    /// Top Back button of the Controller
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_close")?.withTintColor(.white), for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    /// Flip Camera button
    private let cameraFlipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_camera_flip"), for: .normal)
        button.addTarget(self, action: #selector(flipCameraAction), for: .touchUpInside)
        return button
    }()
    
    
    /// Recapturing button
    private let reCaputreButton: CircularUIButton = {
        let button = CircularUIButton(image: #imageLiteral(resourceName: "retry_icon").imageWithColor(color1: .gray))
        button.addTarget(self, action: #selector(backToCameraView), for: .touchUpInside)
        return button
    }()
    
    
    /// The button responsible for sending the image back
    private let sendImageButton: CircularUIButton = {
        let button = CircularUIButton(image: #imageLiteral(resourceName: "check_icon").imageWithColor(color1: UIHelper.instance.mainColor))
        button.addTarget(self, action: #selector(sendImageBackAction), for: .touchUpInside)
        return button
    }()

    
    /// The capture image button
    private let cameraCaptureButtonView: CameraCaptureButtonView = {
        let button = CameraCaptureButtonView()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    /// Bottom white container view
    private let buttonsBottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.addViewShadow()
        return view
    }()
    
    
    /// The confirmation label of the image
    private let imageConfirmationLabel: CHeaderUILabel = {
        let label = CHeaderUILabel()
        label.text = Global.Strings.proceedWithImage
        label.textColor = UIHelper.instance.appBlackColor
        return label
    }()

    //Buttons Constrains to animate them
    private var sendImageButtonBottomConstrains: NSLayoutConstraint = NSLayoutConstraint()
    private var reCaputreButtonBottomConstrains: NSLayoutConstraint = NSLayoutConstraint()
    private var bottomViewHightConstraint: NSLayoutConstraint = NSLayoutConstraint()

    
    /// View model of the camera view controller
    private lazy var viewModel: AVFaceDetectionCamViewModel = {
        return DefaultAVFaceDetectionCamViewModel(with: self)
    }()
    
    /// Haptic sensation generator
    internal static let hapticGenerator = UISelectionFeedbackGenerator()

    ///Delegate that is responsible for returning the UIImage
    open weak var delegate: AVFaceDetectionCamVCDelegate?

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        cameraView.isSessionRunning = true
        viewModel.startCameraFeed()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        cameraView.isSessionRunning = false
        viewModel.stopCameraFeed()

    }

    
    //MARK:- Setting the UI of the view
    func setupUI() {
        guard viewModel.haveCameraAccess else {
            setupAllowPermissionView()
            return
        }
        cameraView = CameraUIView(frame: view.bounds)
        view.addSubview(cameraView)
        #if targetEnvironment(simulator)
        cameraView.backgroundColor = .magenta
        #else
        viewModel.cameraManager.setupCameraView(view: cameraView)
        cameraView.addViews()
        #endif
        addBackButton()
        addCaptureButton()
        addFlipCameraButton()
        addingToolTip()
        addCaptureButtons()
        cameraCaptureButtonView.delegate = self



    }
    

    ///Setuping the Permission View
    private func setupAllowPermissionView(){
        view.addSubview(requestAuthView)
        requestAuthView.frame = view.bounds
        requestAuthView.animateInViews()
        requestAuthView.delegate = self
    }
    
    ///Dismissing the ViewController
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    ///A function responsible for fliping the camera Front/Back
    @objc func flipCameraAction(){
        cameraView.blurrPreview()
        UIView.transition(with: cameraView, duration: 0.5,
                          options: .transitionFlipFromLeft, animations: { [weak self] in
                            Self.hapticGenerator.selectionChanged()
                            self?.viewModel.flipCamera {
                                self?.cameraView.unblurrPreview()
                            }
                          }, completion: nil)
        
    }
    
    @objc private func backToCameraView(){

        navigationController?.navigationBar.isHidden = true
        cameraCaptureButtonView.isHidden = false
        cameraFlipButton.isHidden = false
        backButton.isHidden = false
        viewModel.startCameraFeed()
        cameraView.hideImageView()
        animateBottomButtonsOut()
    }
    
    
    @objc private func sendImageBackAction(){
        guard let image = viewModel.capturedImage else { return }
        delegate?.didReturnUserFaceImage(image: image)
    }
    
}

//MARK:- RequestCameraPermissionViewDelegate Functions
extension AVFaceDetectionCamVC: RequestCameraPermissionViewDelegate {
    
    /// Allow button tapping action
    func didTapAllowButton() {
        RequestsHelper.requestCameraPermission { [weak self] cameraStatus in
            guard let self = self else {return}
            switch cameraStatus {
            case .granted:
                self.requestAuthView.animateOutViews {
                    self.requestAuthView.removeFromSuperview()
                    self.setupUI()
                }
            case .notRequested: break
            case .unauthorized:
                self.openSettingsUIAlertView()
            }
        }
    }
    
    

    
}

//MARK:- Setup Views Constrains
extension AVFaceDetectionCamVC {
    
    private func addBackButton() {
        cameraView.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: cameraView.safeAreaLayoutGuide.topAnchor,constant: 10),
            backButton.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 30)
            
        ])
    }
    
    private func addFlipCameraButton() {
        cameraView.addSubview(cameraFlipButton)
        NSLayoutConstraint.activate([
            cameraFlipButton.centerYAnchor.constraint(equalTo: cameraCaptureButtonView.centerYAnchor),
            cameraFlipButton.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor, constant: -20),
            cameraFlipButton.heightAnchor.constraint(equalToConstant: 40),
            cameraFlipButton.widthAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    private func addCaptureButton() {
        view.addSubview(cameraCaptureButtonView)
        NSLayoutConstraint.activate([
            cameraCaptureButtonView.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            cameraCaptureButtonView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: -40),
            cameraCaptureButtonView.heightAnchor.constraint(equalToConstant: 70),
            cameraCaptureButtonView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func addCaptureButtons() {
        view.addSubview(buttonsBottomView)
        view.addSubview(imageConfirmationLabel)
        view.addSubview(reCaputreButton)
        view.addSubview(sendImageButton)
        
        reCaputreButtonBottomConstrains = reCaputreButton.centerYAnchor.constraint(equalTo: buttonsBottomView.centerYAnchor, constant: 200)
        sendImageButtonBottomConstrains = sendImageButton.centerYAnchor.constraint(equalTo: buttonsBottomView.centerYAnchor, constant: 200)
        bottomViewHightConstraint = buttonsBottomView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            buttonsBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsBottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsBottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomViewHightConstraint,
            
            imageConfirmationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageConfirmationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageConfirmationLabel.topAnchor.constraint(equalTo: buttonsBottomView.topAnchor,constant: 20),
            
            reCaputreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -view.frame.width/4),
            reCaputreButtonBottomConstrains,
            reCaputreButton.heightAnchor.constraint(equalToConstant: 60),
            reCaputreButton.widthAnchor.constraint(equalToConstant: 60),
            
            sendImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: view.frame.width/4),
            sendImageButtonBottomConstrains,
            sendImageButton.heightAnchor.constraint(equalToConstant: 60),
            sendImageButton.widthAnchor.constraint(equalToConstant: 60)
            
            
        ])
    }
    
    /// Adding the tooltip function
    func addingToolTip(){
        view.showTooltip(message: Global.Strings.addingTooltipDesc, direction: .down,inView: cameraCaptureButtonView)
    }
    
    
    /// Showing the image view the has been captured
    private func showImageView(){
        cameraCaptureButtonView.isHidden = true
        cameraFlipButton.isHidden = true
        reCaputreButton.isHidden = false
        sendImageButton.isHidden = false
        view.bringSubviewToFront(buttonsBottomView)
        view.bringSubviewToFront(reCaputreButton)
        view.bringSubviewToFront(sendImageButton)
        view.bringSubviewToFront(imageConfirmationLabel)

        viewModel.stopCameraFeed()
        cameraView.showImageView(image: viewModel.capturedImage ?? UIImage())
        animateBottomButtonsIn()
        
    }
    
    /// Animate the recaptuer and sendback Buttons and view in
    private func animateBottomButtonsIn(){
        imageConfirmationLabel.alpha = 0
        bottomViewHightConstraint.constant = 150
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            self?.imageConfirmationLabel.alpha = 1

        }, completion: nil)
        
        sendImageButtonBottomConstrains.constant = 20
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
        
        reCaputreButtonBottomConstrains.constant = 20
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseInOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    /// Animate the recaptuer and sendback Buttons and view out
    private func animateBottomButtonsOut(){
        imageConfirmationLabel.alpha = 1
        bottomViewHightConstraint.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseInOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            self?.imageConfirmationLabel.alpha = 0

        }, completion: nil)
        
        sendImageButtonBottomConstrains.constant = 200
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
        
        reCaputreButtonBottomConstrains.constant = 200
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}

//MARK:- CameraViewModelDelegate Functions
extension AVFaceDetectionCamVC: AVFaceDetectionCamViewModelDelegate {
    func updateImageView() {
        showImageView()
    }
    
    func realTimeFaceDetection(hasFace: Bool, faceFrame: CGRect) {
        cameraCaptureButtonView.isButtonActive = hasFace
        cameraView.showMissingFace(show: hasFace)
        
    }
    
}

//MARK:- CameraCaptureButtonViewDelegate Functions
extension AVFaceDetectionCamVC: CameraCaptureButtonViewDelegate {
    /// Taking picture action
    func didTakeImage() {
        cameraView.blurrPreview()
        viewModel.takePicture = true
        Self.hapticGenerator.selectionChanged()
    }
    
}
