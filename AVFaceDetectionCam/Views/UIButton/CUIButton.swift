//
//  CUIButton.swift
//  TestApp
//
//  Created by Ali on 8/21/21.
//

import UIKit

class CUIButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    public init(title: String, backgroundColor: UIColor) {
        super.init(frame: .zero)
        setupUI()
        setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        
    }

    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIHelper.instance.mainColor
        titleLabel?.font = Fonts.Semibold.twenty
        setTitleColor(.white, for: .normal)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.4
        layer.cornerRadius = 10
        layer.shadowOffset = CGSize(width: 5, height: 10)
    }
}
