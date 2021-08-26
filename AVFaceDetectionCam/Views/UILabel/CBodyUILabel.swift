//
//  CBodyUILabel.swift
//  TestApp
//
//  Created by Ali on 8/21/21.
//

import UIKit

class CBodyUILabel: UILabel {


    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLabel()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    init(textColor: UIColor? = .gray, font: UIFont? = Fonts.Regular.eighteen) {
        super.init(frame: .zero)
        self.font = font
        self.textColor = textColor
    }

    
    private func setupLabel() {
        translatesAutoresizingMaskIntoConstraints = false
        font = Fonts.Regular.eighteen
        textAlignment = .center
        textColor = .gray
        numberOfLines = 0

    }
}
