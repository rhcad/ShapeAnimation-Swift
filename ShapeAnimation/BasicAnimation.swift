//
//  BasicAnimation.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/20.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import UIKit
import QuartzCore
import SwiftGraphics

// MARK: Animation extension of CALayer

public extension CALayer {
    typealias Radians = CGFloat
    typealias RelativePoint = CGPoint
    
    func opacityAnimation(#from:Float, to:Float) -> AnimationPair {
        return opacityAnimation(from:from, to:to, didStop:nil)
    }
    
    func opacityAnimation(#from:Float, to:Float, didStop:(() -> Void)?) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"opacity")
        animation.duration = 0.8
        animation.fromValue = from
        animation.toValue = to
        animation.didStop = didStop
        animation.removedOnCompletion = false
        self.opacity = to
        return AnimationPair(self, animation)
    }
    
    func flashAnimation(repeatCount n:Float) -> AnimationPair {
        return opacityAnimation(from:0, to:1).set {
            $0.repeatCount = n
            $0.autoreverses = true
            $0.duration = 0.2
        }
    }
    
    func scaleAnimation(#from:Float, to:Float) -> AnimationPair {
        return scaleAnimation(from:from, to:to, didStop:nil)
    }
    
    func scaleAnimation(#from:Float, to:Float, didStop:(() -> Void)?) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"transform.scale")
        animation.duration = 0.8
        animation.fromValue = from
        animation.toValue = to
        animation.didStop = didStop
        animation.autoreverses = true
        animation.removedOnCompletion = false
        return AnimationPair(self, animation)
    }
    
    func scaleAnimation(#from:Float, to:Float, repeatCount:Float) -> AnimationPair {
        return scaleAnimation(from:from, to:to, didStop:nil).set {$0.repeatCount=repeatCount}
    }
    
    func rotate360Degrees() -> AnimationPair {
        return rotationAnimation(angle:Radians(2 * M_PI), didStop:nil)
    }
    
    func rotationAnimation(#angle:Radians) -> AnimationPair {
        return rotationAnimation(angle:angle, didStop:nil)
    }
    
    func rotationAnimation(#angle:Radians, didStop:(() -> Void)?) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"transform.rotation")
        animation.duration = 0.8
        animation.additive = true
        animation.fromValue = 0.0
        animation.toValue = angle
        animation.didStop = didStop
        animation.removedOnCompletion = false
        return AnimationPair(self, animation)
    }
    
    func shakeAnimation() -> AnimationPair {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, 0]
        animation.duration = 0.8
        animation.additive = true
        animation.removedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        return AnimationPair(self, animation)
    }
    
    func moveAnimation(#to:RelativePoint) -> AnimationPair {
        return moveAnimation(from:CGPoint.zeroPoint, to:to)
    }
    
    func moveAnimation(#from:RelativePoint, to:RelativePoint) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"position")
        animation.duration = 0.5
        animation.additive = true
        animation.fromValue = NSValue(CGPoint: from)
        animation.toValue = NSValue(CGPoint: to)
        animation.removedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        return AnimationPair(self, animation)
    }
    
    func moveOnPathAnimation(path:CGPath) -> AnimationPair {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.path = path
        animation.duration = 0.8
        animation.removedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        return AnimationPair(self, animation)
    }
    
    func slideToRight() -> AnimationPair {
        let slide = CATransition()
        
        slide.type = kCATransitionPush
        slide.subtype = kCATransitionFromLeft
        slide.duration = 0.8
        slide.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slide.fillMode = kCAFillModeRemoved
        return AnimationPair(self, slide)
    }
    
}

// MARK: Animation extension of CAShapeLayer

public extension CAShapeLayer {

    func strokeEndAnimation() -> AnimationPair {
        return strokeEndAnimation(nil)
    }
    
    func strokeEndAnimation(#from:Float, to:Float) -> AnimationPair {
        return strokeEndAnimation(from:from, to:to, didStop:nil)
    }
    
    func strokeEndAnimation(didStop:(() -> Void)?) -> AnimationPair {
        return strokeEndAnimation(from:0, to:1.0, didStop:didStop)
    }
    
    func strokeEndAnimation(#from:Float, to:Float, didStop:(() -> Void)?) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"strokeEnd")
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.didStop = didStop
        animation.removedOnCompletion = false
        return AnimationPair(self, animation)
    }
    
    func strokeColorAnimation(#from:UIColor, to:UIColor) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"strokeColor")
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = from.CGColor
        animation.toValue = to.CGColor
        animation.removedOnCompletion = false
        return AnimationPair(self, animation)
    }
    
    func lineWidthAnimation(#from:CGFloat, to:CGFloat) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"lineWidth")
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = from
        animation.toValue = to
        animation.removedOnCompletion = false
        return AnimationPair(self, animation)
    }
    
    func dashPhaseAnimation(#from:CGFloat, to:CGFloat) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"lineDashPhase")
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
        animation.fromValue = from
        animation.toValue = to
        animation.removedOnCompletion = false
        return AnimationPair(self, animation)
    }
    
    func switchPathAnimation(to:CGPath) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"path")
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.toValue = path
        animation.removedOnCompletion = false
        return AnimationPair(self, animation)
    }
}

// MARK: animationGroup() and applyAnimations()
// animationGroup() for the same layer, and applyAnimations() for multiple layers

public func animationGroup(animations:[AnimationPair]) -> AnimationPair {
    return animationGroup(animations, nil)
}

public func animationGroup(animations:[AnimationPair], didStop:(() -> Void)?) -> AnimationPair {
    let animation = CAAnimationGroup()
    let layer = animations.first!.layer
    
    animation.animations = animations.map {
        assert($0.layer == layer)
        return $0.animation
    }
    for anim in animation.animations {
        animation.duration = max(animation.duration, anim.duration)
    }
    animation.removedOnCompletion = false
    return AnimationPair(layer, animation)
}

public func applyAnimations(animations:[AnimationPair], completion:(() -> Void)?) {
    CATransaction.begin()
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut.substringFromIndex(0)))
    if completion != nil {
        CATransaction.setCompletionBlock(completion)
    }
    var duration:CFTimeInterval = 0
    for la in animations {
        la.apply()
        duration = max(duration, la.animation.duration)
    }
    CATransaction.setAnimationDuration(duration)
    CATransaction.commit()
}

// MARK: Pair of layer and animation

public class AnimationPair {
    public let layer:CALayer
    public let animation:CAAnimation
    public var key = "TGAnimation"
    
    init(_ layer:CALayer, _ animation:CAAnimation) {
        self.layer = layer
        self.animation = animation
    }
    
    public func set(did:(CAAnimation) -> Void) -> AnimationPair {
        did(self.animation)
        return self
    }
    
    public func setStop(didStop:() -> Void) -> AnimationPair {
        animation.didStop = didStop
        return self
    }
    
    public func setDuration(d:CFTimeInterval) -> AnimationPair {
        animation.duration = d
        if let group = animation as? CAAnimationGroup {
            for sub in group.animations {
                let subanim = sub as CAAnimation
                subanim.duration = d
            }
        }
        return self
    }
    
    public func setBeginTime(index:Int, gap:CFTimeInterval, duration:CFTimeInterval) -> AnimationPair {
        animation.beginTime = CACurrentMediaTime() + Double(index) * gap
        setDuration(duration)
        return self
    }
    
    public func apply() {
        layer.addAnimation(animation, forKey:key)
        if let gradientLayer = layer.gradientLayer {
            gradientLayer.addAnimation(animation, forKey:key)
        }
    }
    
    public func apply(didStop:(() -> Void)?) {
        animation.didStop = didStop
        apply()
    }
    
    public func apply(duration d:CFTimeInterval) {
        setDuration(d)
        apply()
    }
    
    public func apply(duration d:CFTimeInterval, didStop:(() -> Void)?) {
        setDuration(d)
        animation.didStop = didStop
        apply()
    }
}
