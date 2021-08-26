//
//  CameraUIView.swift
//  TestApp
//
//  Created by Ali on 8/22/21.
//

import UIKit

class CameraUIView: UIView {

    //MARK:- Setting up the view variables and constants
    private(set) var isBlurred = false

    private let visualEffect = UIBlurEffect(style: .light)
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: self.visualEffect)
        view.isHidden = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let capturedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var missingFace: MissingFaceView = {
        let view = MissingFaceView()
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    
    private func setupUI() {
        visualEffectView.frame = bounds
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    /// A variable that if the session is interrupted it will blurr or unblurr the view
    var isSessionRunning = false {
        didSet {
            if isSessionRunning {
                unblurrPreview()
            } else {
                blurrPreview()
            }
        }
    }

    /// Showing the UIImage captured
    func showImageView(image: UIImage) {
        missingFace.isHidden = true
        capturedImageView.image = image
        capturedImageView.isHidden = false
        unblurrPreview(time: 0.5)

    }
    
    
    /// Hide the UIImage captured
    func hideImageView() {
        blurrPreview()
        capturedImageView.isHidden = true
        UIView.animate(withDuration: 1.0){ [weak self] in
            self?.transform = CGAffineTransform(scaleX: 1, y: 1)
            self?.layer.cornerRadius = 0
        }
        unblurrPreview(time: 0.5)

    }
    
    /// Adding the captured image to the view
    private func addCapturedImage() {
        addSubview(capturedImageView)
        capturedImageView.frame = layer.bounds
    }
    
    /// A funtion that unblurres the view
    /// - Parameter time: the time of unblurring a view
    func blurrPreview(time: TimeInterval = 0.25) {
        guard !isBlurred else {
            return
        }
        bringSubviewToFront(visualEffectView)
        visualEffectView.frame = bounds
        visualEffectView.effect = nil
        isBlurred = true
        self.visualEffectView.isHidden = false
        UIView.animate(withDuration: time) {
            self.visualEffectView.effect = self.visualEffect
        }
    }

    
    /// A funtion that blurres the view
    /// - Parameter time: the time of blurring a view
    func unblurrPreview(time: TimeInterval = 0.25) {
        guard isBlurred else {
            return
        }

        isBlurred = false
        UIView.animate(withDuration: time, animations: {
            self.visualEffectView.effect = nil
        }, completion: { (success) in
            if success {
                self.visualEffectView.isHidden = true
            }
        })
    }
    
    
    func showMissingFace(show: Bool) {
        missingFace.isHidden = show ? true : false

    }
    
    
    func addViews() {
        addCapturedImage()
        addSubview(missingFace)
        addSubview(visualEffectView)
        
        NSLayoutConstraint.activate([
            missingFace.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: 0),
            missingFace.centerXAnchor.constraint(equalTo: centerXAnchor),
            
        ])
        
    }
    
    
}
