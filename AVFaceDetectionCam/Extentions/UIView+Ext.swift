//
//  UIView+Ext.swift
//  TestApp
//
//  Created by Ali on 8/24/21.
//

import UIKit


// UIView extension specially used for the TooltipView
extension UIView {
    
    
    /// Showing the tooltip in a specific UIView
    /// - Parameters:
    ///   - message: The message of Tooltip
    ///   - direction: Tooltip arrow direction Below/Right
    ///   - inView: The specific UIView you want to tooltip it
    func showTooltip(message: String,
                     direction: TooltipDirection,
                     inView: UIView
    ) {
        removeTooltipView()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            let darkView = UIView()
            darkView.alpha = 0
            darkView.backgroundColor = .black
            darkView.frame = self.bounds
            self.addSubview(darkView)
            darkView.isUserInteractionEnabled = true
            inView.isUserInteractionEnabled = false
            self.bringSubviewToFront(darkView)
            self.bringSubviewToFront(inView)
            
            UIView.animate(withDuration: 1) {
                darkView.alpha = 0.8
            }
            
            var tooltipView: TooltipView
            
            tooltipView = TooltipView.newInstance()
            tooltipView.message = message
            tooltipView.onActionCallback = ({ [weak self] in
                
                UIView.animate(withDuration: 0.5) {
                    darkView.alpha = 0
                    tooltipView.alpha = 0
                } completion: { _ in
                    darkView.removeFromSuperview()
                    inView.isUserInteractionEnabled = true
                    self?.removeTooltipView()
                }
            })
            
            tooltipView.rightIndicatorView.isHidden = direction != .right
            tooltipView.bottomIndicatorView.isHidden = direction != .down
            
            self.addSubview(tooltipView)
            
            switch direction {
            case .down:
                NSLayoutConstraint.activate([
                    tooltipView.centerXAnchor.constraint(equalTo: inView.centerXAnchor, constant: 0)
                ])
                
                NSLayoutConstraint.activate([
                    tooltipView.bottomAnchor.constraint(equalTo: inView.topAnchor, constant: -10),
                ])
            case .right:
                NSLayoutConstraint.activate([
                    tooltipView.centerYAnchor.constraint(equalTo: inView.centerYAnchor, constant: 0)
                ])
                
                NSLayoutConstraint.activate([
                    tooltipView.centerYAnchor.constraint(equalTo: inView.centerYAnchor, constant: 0),
                    tooltipView.rightAnchor.constraint(equalTo: inView.leftAnchor, constant: 0),
                    tooltipView.leadingAnchor.constraint(equalTo: inView.leadingAnchor, constant: 0)
                ])
            }
            
            tooltipView.show()
        }
    }
    
    /// Removes all the tooltips from a view
    public func removeTooltipView() {
        DispatchQueue.main.async {
            for subview in self.subviews where subview is TooltipView {
                subview.removeFromSuperview()
            }
        }
    }
    
    /// Adds a shadow to UIView
    /// - Parameters:
    ///   - color: The color of the shadow
    ///   - opacity: The shadow opacity
    ///   - radius: The shadow radius
    public func addViewShadow(color: UIColor = .gray, opacity: Float = 0.5, radius: CGFloat = 3) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}

