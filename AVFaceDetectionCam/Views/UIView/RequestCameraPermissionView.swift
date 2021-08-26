//
//  RequestCameraPermissionView.swift
//  TestApp
//
//  Created by Ali on 8/21/21.
//

import UIKit

protocol RequestCameraPermissionViewDelegate: AnyObject {
    func didTapAllowButton()
}


/// A UIView for the request permission view
class RequestCameraPermissionView: UIView {

    private struct Constants {
        static let imageSize: CGFloat = 200
        static let imageTopSpace: CGFloat = 150
        static let labelTopSpace: CGFloat = 20
        static let buttonWidth: CGFloat = 130
        static let buttonHeight: CGFloat = 50
        static let buttonTopSpace: CGFloat = 50
    }
    
    //MARK:- Setting the vars and constants of UIView
    private let camerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "camera_icon"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
 
    private let camerAuthHeaderLabel: CHeaderUILabel = {
        let label = CHeaderUILabel()
        label.text = Global.Strings.cameraAuth
        return label
    }()
    
    private let cameraAuthDescriptionLabel: CBodyUILabel = {
        let label = CBodyUILabel()
        label.text = Global.Strings.accessCameraPermission

        return label
    }()
    
    private let allowButton: CUIButton = {
        let button = CUIButton(title: Global.Strings.allow, backgroundColor: UIHelper.instance.mainColor)
        button.addTarget(self, action: #selector(allowButtonAction), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: RequestCameraPermissionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    //MARK:- Settign up the UI of the view
    func setupUI() {
        addSubview(camerImageView)
        addSubview(camerAuthHeaderLabel)
        addSubview(cameraAuthDescriptionLabel)
        addSubview(allowButton)

        NSLayoutConstraint.activate([
            camerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            camerImageView.topAnchor.constraint(equalTo: topAnchor,constant: Constants.imageTopSpace ),
            camerImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            camerImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            
            camerAuthHeaderLabel.topAnchor.constraint(equalTo: camerImageView.bottomAnchor,constant: Constants.labelTopSpace),
            camerAuthHeaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            camerAuthHeaderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),

            cameraAuthDescriptionLabel.topAnchor.constraint(equalTo: camerAuthHeaderLabel.bottomAnchor,constant: Constants.labelTopSpace),
            cameraAuthDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            cameraAuthDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            
            allowButton.topAnchor.constraint(equalTo: cameraAuthDescriptionLabel.bottomAnchor,constant: Constants.buttonTopSpace),
            allowButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            allowButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            allowButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),

        ])



    }
    
    
    @objc func allowButtonAction() {
        delegate?.didTapAllowButton()
    }
    
    
    /// Animate all the views in
    func animateInViews() {
        camerImageView.alpha = 0
        camerAuthHeaderLabel.alpha = 0
        cameraAuthDescriptionLabel.alpha = 0
        allowButton.alpha = 0
        
        let views = [camerImageView,camerAuthHeaderLabel,cameraAuthDescriptionLabel,allowButton]
        for (i,view) in views.enumerated() {
            animateInView(with: view, delay: Double(i) * 0.15)
        }

    }
    /// Animate all the views out
    func animateOutViews(completionHandler: @escaping () -> Void) {
        let views = [camerImageView,camerAuthHeaderLabel,cameraAuthDescriptionLabel,allowButton]
        var completionHandlerToUse: (()-> Void)? = nil
        for (i,view) in views.enumerated() {
            if view == views.last {
                completionHandlerToUse = completionHandler
            }
            animateOutView(with: view, delay: Double(i) * 0.15, completionHandler: completionHandlerToUse)
        }

    }
    
    ///Animate One view In
    private func animateInView(with view: UIView, delay: TimeInterval) {
        view.alpha = 0
        view.transform = CGAffineTransform(translationX: 0, y: -20)
        
        let animate = UIViewPropertyAnimator(duration: 0.15, curve: .easeInOut) {
            view.alpha = 1
            view.transform = .identity
        }
        animate.startAnimation(afterDelay: delay)
    }
    
    ///Animate One view out
    private func animateOutView(with view: UIView, delay: TimeInterval, completionHandler: (() -> Void)?) {
        
        let animate = UIViewPropertyAnimator(duration: 0.15, curve: .easeInOut) {
            view.alpha = 0
            view.transform = CGAffineTransform(translationX: 0, y: -20)
        }
        
        animate.addCompletion { _ in
            completionHandler?()
        }
        animate.startAnimation(afterDelay: delay)
    }
}
