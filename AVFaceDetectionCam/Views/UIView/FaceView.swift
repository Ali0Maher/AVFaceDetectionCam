//
//  FaceView.swift
//  TestApp
//
//  Created by Ali on 8/26/21.
//

import UIKit

class FaceView: UIView {


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var boundingBox = CGRect.zero

    func clear() {
        boundingBox = .zero
        DispatchQueue.main.async {
          self.setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
//        // 1
//        guard let context = UIGraphicsGetCurrentContext() else {
//          return
//        }
//
//        // 2
//        context.saveGState()
//
//        // 3
//        defer {
//          context.restoreGState()
//        }
//
//        // 4
//        context.addRect(boundingBox)
//
//        // 5
//        UIColor.red.setStroke()
//
//        // 6
//        context.strokePath()
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        ctx.stroke(boundingBox)
    }
}
