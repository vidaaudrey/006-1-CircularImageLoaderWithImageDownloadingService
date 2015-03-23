//
//  CircularLoaderView.swift
//  Circular-Image-Loader-Animation
//
//  Created by Audrey Li on 3/19/15.
//  Copyright (c) 2015 Shomigo. All rights reserved.
//

import UIKit

class CircularLoaderView: UIView {

    var circlePathLayer = CAShapeLayer()
    var gradientMaskLayer: CAGradientLayer!
    var circleRadius: CGFloat = 100.0
    var progressLabel: UILabel!
    var circleStrokeColors:[UIColor]!
    
    var progress: CGFloat {
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            if newValue > 1 {
                circlePathLayer.strokeEnd = 1
            } else if newValue < 0 {
                circlePathLayer.strokeEnd = 0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        progress = 0
        createLabel()
    //    backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        customizeCirclePathLayer()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().CGPath
       
    }
  
    
    func customizeCirclePathLayer() {
        
        circleStrokeColors = [UIColor.blueColor(), UIColor.redColor()]
        
        circlePathLayer.lineWidth = 15
        circlePathLayer.fillColor = UIColor.clearColor().CGColor
        circlePathLayer.strokeColor = UIColor.blackColor().CGColor
        
        gradientMaskLayer = gradientMask()
        gradientMaskLayer.mask = circlePathLayer
        layer.addSublayer(gradientMaskLayer)
       
    }
    
    private func gradientMask() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.colors = circleStrokeColors.map{$0.CGColor}
        return gradientLayer
    }
    
    func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
        circleFrame.origin = CGPointMake(CGRectGetMidX(circlePathLayer.bounds) - CGRectGetMidX(circleFrame), CGRectGetMidY(circlePathLayer.bounds) - CGRectGetMidY(circleFrame))
       
        return circleFrame
        
    }
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalInRect: circleFrame())
    }
    
    func reveal() {
        backgroundColor = UIColor.clearColor()
        //Removes any pending implicit animations for the strokeEnd property, which may have otherwise interfered with the reveal animation
        circlePathLayer.removeAnimationForKey("strokeEnd")
        gradientMaskLayer.removeFromSuperlayer()
        superview?.layer.mask = circlePathLayer
        
        let center = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds))
        let finalRadius = sqrt((center.x * center.x) + (center.y * center.y))
        let radiusInset = finalRadius - circleRadius
        let outerRect = CGRectInset(circleFrame(), -radiusInset, -radiusInset)
        let toPath = UIBezierPath(ovalInRect: outerRect).CGPath
        
        let fromPath = circlePathLayer.path
        let fromLineWidth = circlePathLayer.lineWidth
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        circlePathLayer.lineWidth = 2 * finalRadius
        circlePathLayer.path = toPath
        CATransaction.commit()
        
        let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnimation.fromValue = fromLineWidth
        lineWidthAnimation.toValue = 2 * finalRadius
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = fromPath
        pathAnimation.toValue = toPath
        
        // Add both animations to a CAAnimationGroup, and add the animation group to the layer.
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 1
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        groupAnimation.animations = [pathAnimation, lineWidthAnimation]
        groupAnimation.delegate = self
        circlePathLayer.addAnimation(groupAnimation, forKey: "strokeWidth")
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        superview?.layer.mask = nil
    }
    
    private func createLabel() {
        progressLabel = UILabel(frame: CGRectMake(0.0, 0.0, CGRectGetWidth(frame),  60.0))
        progressLabel.textColor = UIColor.blackColor()
        progressLabel.textAlignment = .Center
        progressLabel.text = "Load Image"
        progressLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 40)
        progressLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(progressLabel)
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }

}
