//
//  TooltipView.swift
//  TestApp
//
//  Created by Ali on 8/24/21.
//

import UIKit


/// An enum for tooltips arrow direction
enum TooltipDirection {
    case down
    case right
}


class TooltipView: UIView {
    
    /// Constants that has been used in the UIView
    internal enum Constants {
        static let defaultMargin: CGFloat = 16.0
        static let skipBtnHeight: CGFloat = 20
        static let buttonCornerRadius: CGFloat = 4
        static let indicatorWidth: CGFloat = 20
        static let indicatorHeight: CGFloat = 15
        static let viewHeight: CGFloat = 181
        static let viewWidth: CGFloat = 320
        static let viewMinimumHeight: CGFloat = 50
        static let arrowBottomMargin: CGFloat = 3
        static let descriptionMargin: CGFloat = 10
    }
    //MARK:- Setting the vars and constants
    private let tooltipDescription: CBodyUILabel = {
        let label = CBodyUILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        return button
    }()
    internal var contentView = UIView()

    var onActionCallback: (() -> Void)?
    lazy var bottomIndicatorView = TriangleView()
    lazy var rightIndicatorView = TriangleView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    /// Returns an instants of the tooltip
    /// - Returns: returns a TooltipView UIVIew
    static func newInstance() -> TooltipView {
        let tooltip = TooltipView()
        tooltip.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tooltip.widthAnchor.constraint(equalToConstant: Constants.viewWidth),
            tooltip.heightAnchor.constraint(equalToConstant: Constants.viewHeight),
        ])
        tooltip.setupTooltipPopup()
        return tooltip
    }
    lazy var message: String = "" {
        didSet {
            tooltipDescription.text = message
        }
    }
    
    
    /// Setuping the Tooltip
    func setupTooltipPopup() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        rightIndicatorView.direction = .right
        rightIndicatorView.color = UIHelper.instance.secondaryColor
        addSubview(rightIndicatorView)
        NSLayoutConstraint.activate([
            rightIndicatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightIndicatorView.widthAnchor.constraint(equalToConstant: Constants.indicatorHeight),
            rightIndicatorView.heightAnchor.constraint(equalToConstant: Constants.indicatorWidth),
            rightIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        bottomIndicatorView.direction = .down
        bottomIndicatorView.color = UIHelper.instance.secondaryColor
        bottomIndicatorView.backgroundColor = UIColor.clear
        addSubview(bottomIndicatorView)
        NSLayoutConstraint.activate([
            bottomIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomIndicatorView.widthAnchor.constraint(equalToConstant: Constants.indicatorWidth),
            bottomIndicatorView.heightAnchor.constraint(equalToConstant: Constants.indicatorHeight),
            bottomIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        contentView.layer.cornerRadius = Constants.indicatorHeight
        contentView.backgroundColor = UIHelper.instance.secondaryColor
        contentView.layer.cornerRadius = Constants.indicatorHeight
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomIndicatorView.topAnchor,constant: Constants.arrowBottomMargin),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: rightIndicatorView.leadingAnchor,constant: Constants.arrowBottomMargin),
            contentView.heightAnchor.constraint(equalToConstant: Constants.viewMinimumHeight),
        ])
        
        contentView.addSubview(nextButton)
        
        nextButton.titleLabel?.font = Fonts.Semibold.fourteen
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.backgroundColor = UIHelper.instance.mainColor
        nextButton.isUserInteractionEnabled = true
        nextButton.isEnabled = true
        nextButton.layer.cornerRadius = Constants.buttonCornerRadius
        nextButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: Constants.defaultMargin,
                                                    bottom: 0, right: Constants.defaultMargin)
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -Constants.descriptionMargin),
            nextButton.heightAnchor.constraint(equalToConstant: Constants.skipBtnHeight),
        ])
        contentView.addSubview(tooltipDescription)
        NSLayoutConstraint.activate([
            tooltipDescription.topAnchor.constraint(equalTo: contentView.topAnchor,constant: Constants.descriptionMargin),
            tooltipDescription.bottomAnchor.constraint(equalTo: nextButton.topAnchor,constant: -Constants.descriptionMargin),
            tooltipDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: Constants.descriptionMargin),
            tooltipDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -Constants.descriptionMargin),
        ])
        tooltipDescription.text = message
    }
    
    
    /// Showing the tooltip with animation
    func show(){
        fadeIn()
    }
    
    /// fade the Tooltip view with animation view
    /// - Parameter completion: A completion handler after the UIView fades in 
    func fadeIn(completion: (() -> Void)? = nil) {
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 1
        }, completion: { _ in
            completion?()
        })
    }
    
    
    @objc func nextButtonAction(){
        onActionCallback?()
    }
}
