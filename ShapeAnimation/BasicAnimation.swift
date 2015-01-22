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

public extension CALayer {
    
    func opacityAnimation(from f:Float, to:Float) -> AnimationPair {
        return opacityAnimation(from:f, to:to, didStop:nil)
    }
    
    func opacityAnimation(from f:Float, to:Float, didStop:(() -> Void)?) -> AnimationPair {
        var animation = CABasicAnimation(keyPath:"opacity")
        animation.duration = 0.8
        animation.fromValue = f
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
    
    func scaleAnimation(from f:Float, to:Float) -> AnimationPair {
        return scaleAnimation(from:f, to:to, didStop:nil)
    }
    
    func scaleAnimation(from f:Float, to:Float, didStop:(() -> Void)?) -> AnimationPair {
        var animation = CABasicAnimation(keyPath:"transform.scale")
        animation.duration = 0.8
        animation.fromValue = f
        animation.toValue = to
        animation.didStop = didStop
        animation.autoreverses = true
        animation.removedOnCompletion = false
        return AnimationPair(self, animation)
    }
    
    func scaleAnimation(from f:Float, to:Float, repeatCount:Float) -> AnimationPair {
        return scaleAnimation(from:f, to:to, didStop:nil).set {$0.repeatCount=repeatCount}
    }
    
    func rotate360Degrees() -> AnimationPair {
        return rotationAnimation(angle:CGFloat(2 * M_PI), didStop:nil)
    }
    
    func rotationAnimation(angle a:CGFloat) -> AnimationPair {
        return rotationAnimation(angle:a, didStop:nil)
    }
    
    func rotationAnimation(angle a:CGFloat, didStop:(() -> Void)?) -> AnimationPair {
        var animation = CABasicAnimation(keyPath:"transform.rotation")
        animation.duration = 0.8
        animation.additive = true
        animation.fromValue = 0.0
        animation.toValue = a
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

public extension CAShapeLayer {

    func strokeEndAnimation() -> AnimationPair {
        return strokeEndAnimation(nil)
    }
    
    func strokeEndAnimation(from f:Float, to:Float) -> AnimationPair {
        return strokeEndAnimation(from:f, to:to, didStop:nil)
    }
    
    func strokeEndAnimation(didStop:(() -> Void)?) -> AnimationPair {
        return strokeEndAnimation(from:0, to:1.0, didStop:didStop)
    }
    
    func strokeEndAnimation(from f:Float, to:Float, didStop:(() -> Void)?) -> AnimationPair {
        var animation = CABasicAnimation(keyPath:"strokeEnd")
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.didStop = didStop
        animation.removedOnCompletion = false
        return AnimationPair(self, animation)
    }
    
    func pathAnimation(to:CGPath) -> AnimationPair {
        var animation = CABasicAnimation(keyPath:"path")
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.toValue = path
        animation.removedOnCompletion = false
        return AnimationPair(self, animation)
    }
}

public func animationGroup(animations:[AnimationPair]) -> AnimationPair {
    return animationGroup(animations, nil)
}

public func animationGroup(animations:[AnimationPair], didStop:(() -> Void)?) -> AnimationPair {
    var animation = CAAnimationGroup()
    animation.animations = animations.map { return $0.animation }
    for anim in animation.animations {
        animation.duration = max(animation.duration, anim.duration)
    }
    animation.removedOnCompletion = false
    return AnimationPair(animations.first!.layer, animation)
}

public func applyAnimations(animations:[AnimationPair], completion:(() -> Void)?) {
    CATransaction.begin()
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut.substringFromIndex(0)))
    if completion != nil {
        CATransaction.setCompletionBlock(completion)
    }
    var duration:CFTimeInterval = 0
    for la in animations {
        la.layer.addAnimation(la.animation)
        duration = max(duration, la.animation.duration)
    }
    CATransaction.setAnimationDuration(duration)
    CATransaction.commit()
}

public class AnimationPair : NSObject {
    public var layer:CALayer
    public var animation:CAAnimation
    
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
    
    public func apply() {
        layer.addAnimation(animation)
    }
    
    public func apply(didStop:(() -> Void)?) {
        animation.didStop = didStop
        layer.addAnimation(animation)
    }
    
    public func apply(duration d:CFTimeInterval) {
        setDuration(d)
        layer.addAnimation(animation)
    }
    
    public func apply(duration d:CFTimeInterval, didStop:(() -> Void)?) {
        setDuration(d)
        animation.didStop = didStop
        layer.addAnimation(animation)
    }
}
