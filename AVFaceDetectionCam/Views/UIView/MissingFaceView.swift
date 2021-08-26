//
//  MissingFaceView.swift
//  TestApp
//
//  Created by Ali on 8/23/21.
//

import UIKit


/// The view that shows a message if the camera didn't detect any Human Face
class MissingFaceView: UIView {

    //MARK:- Setting all the variables and constants of the view
    private let camerAuthHeaderLabel: CHeaderUILabel = {
        let label = CHeaderUILabel()
        label.text = Global.Strings.missingFace
        label.textColor = .white
        return label
    }()

    private let faceIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_face"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImageColor(color: UIColor.white)
        return imageView
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    
    //MARK:- Setting up the views
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        addViews()
        animateView()
    }
    
    
    /// Animate the smilly face 
    func animateView() {
        UIView.animate(withDuration: 1) {
            self.faceIconImageView.frame.origin.y -= 20

        } completion: { _ in
            UIView.animateKeyframes(withDuration: 1, delay: 0.25, options: [.autoreverse,.repeat]) {
                self.faceIconImageView.frame.origin.y += 20

            }
        }
        

    }
    
    private func addViews() {
        addSubview(camerAuthHeaderLabel)
        addSubview(faceIconImageView)
        NSLayoutConstraint.activate([
            faceIconImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: 30),
            faceIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            faceIconImageView.heightAnchor.constraint(equalToConstant: 60),
            faceIconImageView.widthAnchor.constraint(equalToConstant: 60),

            camerAuthHeaderLabel.topAnchor.constraint(equalTo: faceIconImageView.bottomAnchor,constant: 10),
            camerAuthHeaderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            camerAuthHeaderLabel.heightAnchor.constraint(equalToConstant: 30),
            
        ])
    }
}
