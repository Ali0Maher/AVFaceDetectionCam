//
//  CircularUIButton.swift
//  TestApp
//
//  Created by Ali on 8/23/21.
//

import UIKit

class CircularUIButton: UIButton {


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    init(image: UIImage) {
        super.init(frame: .zero)
        setImage(image, for: .normal)
        setupUI()
    }
    
    
    private func setupUI() {
        self.layer.cornerRadius = 0.5 * self.bounds.height
        self.translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        imageView?.contentMode = .scaleAspectFit
        backgroundColor = .white
    }
}
