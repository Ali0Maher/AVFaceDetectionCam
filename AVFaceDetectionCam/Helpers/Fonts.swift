//
//  Fonts.swift
//  TestApp
//
//  Created by Ali on 8/21/21.
//

import UIKit

/// A struct with the Framework varios font sizes
public struct Fonts {

    public enum Regular {
        public static let fourteen = UIFont(name: "JosefinSans-Regular", size: 14)
        public static let seventeen = UIFont(name: "JosefinSans-Regular", size: 17.0)
        public static let eighteen = UIFont(name: "JosefinSans-Regular", size: 18)
        public static let sixteen = UIFont(name: "JosefinSans-Regular", size: 16)
        public static let fifteen = UIFont(name: "JosefinSans-Regular", size: 15.0)
        public static let thirteen = UIFont(name: "JosefinSans-Regular", size: 13.0)
    }
    
    public enum Semibold {
        public static let fourteen = UIFont(name: "JosefinSans-SemiBold", size: 14)
        public static let sixteen = UIFont(name: "JosefinSans-SemiBold", size: 16)
        public static let twenty = UIFont(name: "JosefinSans-SemiBold", size: 20)
        public static let twentyFour = UIFont(name: "JosefinSans-SemiBold", size: 24)
    }
}
