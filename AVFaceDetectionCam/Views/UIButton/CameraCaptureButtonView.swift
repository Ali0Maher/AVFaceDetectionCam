//
//  CameraCaptureButtonView.swift
//  TestApp
//
//  Created by Ali on 8/22/21.
//

import UIKit


protocol CameraCaptureButtonViewDelegate: AnyObject {
    func didTakeImage()
}

class CameraCaptureButtonView: UIView {
    
    private struct Constants {
        static let margin: CGFloat = 8.0
        static let borderWidth: CGFloat = 3.0
        static let recordingCornerRadius: CGFloat = 8.0
    }
    
    
    var isButtonActive = false {
        didSet {
            if isButtonActive {
                activateButton()
            } else {
                deActivateButton()
            }
        }
    }
    let captureButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 27.5
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(captureImageAction), for: .touchUpInside)
        return button
    }()
    // Custom Border to the UIButton
    private let border = CALayer()
    
    weak var delegate: CameraCaptureButtonViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = UIColor.white.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = rect.size.width/2
        backgroundColor = UIColor.clear
    }
    
    private func activateButton() {
        captureButton.isEnabled = true
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.captureButton.backgroundColor = .white
        }
    }
    private func deActivateButton() {
        captureButton.isEnabled = false

        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.captureButton.backgroundColor = .gray
        }
    }
    
    @objc func captureImageAction() {
        delegate?.didTakeImage()
    }
    private func setupUI() {
        let margin = Constants.margin * 2
        let widthInnerCircle = frame.size.width - margin
        let heightInnerCircle = frame.size.width - margin
        border.removeFromSuperlayer()
        backgroundColor = UIColor.clear
        
        border.backgroundColor = UIColor.white.cgColor
        border.frame = CGRect(x: Constants.margin, y: Constants.margin,
                              width: widthInnerCircle, height: heightInnerCircle)
        border.cornerRadius = CGFloat(widthInnerCircle/2)
        layer.backgroundColor = UIColor.clear.cgColor
        layer.addSublayer(border)
        addSubview(captureButton)
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            captureButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            captureButton.heightAnchor.constraint(equalToConstant: 55),
            captureButton.widthAnchor.constraint(equalToConstant: 55)
        ])
    }
}
