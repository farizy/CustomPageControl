//
//  CustomPageControl.swift
//  CustomPageControl
//
//  Created by MAC on 20/03/19.
//  Copyright © 2019 frzy. All rights reserved.
//  https://medium.com/@pleelaprasad/custom-page-control-in-ios-600bea3f307a
//

import UIKit

@IBDesignable
class CustomPageControl: UIControl {
    open var numberOfPages: Int = 0 {
        didSet {
            numberOfPages += 2
            for tag in 0 ..< numberOfPages {
                let dot = getDotView()
                dot.tag = tag
                dot.backgroundColor = pageIndicatorTintColor
                self.numberOfDots.append(dot)
            }
        }
    }
    open var currentPage: Int = 0 {
        didSet {
            selectedDot(index: currentPage)
        }
    }
    open var currentPageIndicatorTintColor: UIColor? = .darkGray
    open var pageIndicatorTintColor: UIColor? = .lightGray

    private var numberOfDots = [UIView]() {
        didSet{
            if numberOfDots.count == numberOfPages {
                setupViews()
            }
        }
    }
    
    private lazy var selectedDot: UIView = {
        let dot = UIView()
        setupSelectedDotAppearance(dot: dot)
        dot.translatesAutoresizingMaskIntoConstraints = false
        
        return dot
    }()
    
    private lazy var stackView = UIStackView.init(frame: bounds)
    private lazy var constantSpace = ((stackView.spacing) * CGFloat(numberOfPages - 1) + ((bounds.height * dotHeightMultiplier) * CGFloat(numberOfPages)) - bounds.width)
    private var dotHeightMultiplier: CGFloat = 0.3
    private var dotWidthMultiplier: CGFloat = 0.9
    
    private lazy var selectedLeadingConstraint: NSLayoutConstraint = {
        let constraint = selectedDot.leadingAnchor.constraint(
            equalTo: numberOfDots[0].leadingAnchor, constant: 0)
        return constraint
    }()
    
    override var bounds: CGRect {
        didSet{
            numberOfDots.forEach { (dot) in
                self.setupDotAppearance(dot: dot)
            }
        }
    }
    
    //MARK:- Intialisers
    convenience init() {
        self.init(frame: .zero)
    }
    
    init(withNoOfPages pages: Int) {
        self.numberOfPages = pages
        self.currentPage = 0
        super.init(frame: .zero)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        numberOfDots.forEach { (dot) in
            dot.layer.cornerRadius = dot.bounds.height / 2
        }
        selectedDot.layer.cornerRadius = selectedDot.bounds.height / 2
    }
    
    private func setupViews() {
        
        self.numberOfDots.forEach { (dot) in
            self.stackView.addArrangedSubview(dot)
        }
        
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        self.addConstraints([
            
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: self.heightAnchor),
            
        ])
        
        self.numberOfDots.forEach { dot in
            
            self.addConstraints([
                
                dot.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor),
                dot.widthAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: dotWidthMultiplier, constant: 0),
                dot.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: dotHeightMultiplier, constant: 0)
                
                ])
        }
        
        self.addSubview(selectedDot)
        self.addConstraints([
            selectedDot.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: dotHeightMultiplier, constant: 0),
            selectedDot.widthAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: dotWidthMultiplier * 3, constant: stackView.spacing * 2),
            selectedDot.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor)
            ])
        
        self.addConstraint(selectedLeadingConstraint)
    }
    
    //MARK: Helper methods...
    private func getDotView() -> UIView {
        let dot = UIView()
        self.setupDotAppearance(dot: dot)
        dot.translatesAutoresizingMaskIntoConstraints = false
        return dot
    }
    
    private func setupDotAppearance(dot: UIView) {
        dot.transform = .identity
        dot.layer.masksToBounds = true
        dot.clipsToBounds = true
        dot.backgroundColor = pageIndicatorTintColor
    }
    
    private func setupSelectedDotAppearance(dot: UIView) {
        dot.transform = .identity
        dot.layer.masksToBounds = true
        dot.clipsToBounds = true
        dot.backgroundColor = currentPageIndicatorTintColor
    }
    
    private func selectedDot(index: Int) {
        numberOfDots.forEach { (dot) in
            if dot.tag == index {
                UIView.animate(withDuration: 0.2, animations: {
                    self.removeConstraint(self.selectedLeadingConstraint)
                    self.selectedLeadingConstraint = self.selectedDot.leadingAnchor.constraint(equalTo: self.numberOfDots[index].leadingAnchor, constant: 0)
                    self.addConstraint(self.selectedLeadingConstraint)
                    self.layoutSubviews()
                })
                self.sendActions(for: .valueChanged)
            } else {
                setupDotAppearance(dot: dot)
            }
        }
    }
}
