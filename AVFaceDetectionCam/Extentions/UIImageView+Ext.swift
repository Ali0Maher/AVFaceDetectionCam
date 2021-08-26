//
//  UIImageView+Ext.swift
//  TestApp
//
//  Created by Ali on 8/23/21.
//

import UIKit


extension UIImageView {
    
    /// An Extention for changing the icon colors in a UIView
    /// - Parameter color: The color you want to use for Image
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
