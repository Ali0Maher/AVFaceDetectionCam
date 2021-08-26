//
//  CUILabel.swift
//  TestApp
//
//  Created by Ali on 8/21/21.
//

import UIKit

class CHeaderUILabel: UILabel {


    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLabel()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    public init(textColor: UIColor? = .black, font: UIFont? = Fonts.Semibold.twenty) {
        super.init(frame: .zero)
        self.font = font
        self.textColor = textColor
    }

    
    private func setupLabel() {
        translatesAutoresizingMaskIntoConstraints = false
        font = Fonts.Semibold.twenty
        textAlignment = .center
        textColor = .black
    }
}
