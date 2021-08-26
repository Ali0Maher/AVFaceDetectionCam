//
//  TriangleView.swift
//  TestApp
//
//  Created by Ali on 8/24/21.
//

import UIKit

final class TriangleView: UIView {

    var color: UIColor = .white

    var direction = TooltipDirection.down {
        didSet {
            setNeedsDisplay()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        switch direction {
        case .down:
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.maxY))
        case .right:
            context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: (rect.maxY / 2.0)))
        }
        context.closePath()

        context.setFillColor(color.cgColor)
        context.fillPath()
    }
}
