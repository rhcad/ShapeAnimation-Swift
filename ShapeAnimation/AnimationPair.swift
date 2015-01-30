//
//  AnimationPair.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/20.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import UIKit
import QuartzCore
import SwiftGraphics

// MARK: animationGroup() and applyAnimations()
// animationGroup() for the same layer, and applyAnimations() for multiple layers

public func animationGroup(animations:[AnimationPair], didStop:(() -> Void)? = nil) -> AnimationPair {
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
    return AnimationPair(layer, animation, key:"group")
}

public func applyAnimations(animations:[AnimationPair], completion:(() -> Void)?) {
    CATransaction.begin()
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut.substringFromIndex(0)))
    if completion != nil {
        CATransaction.setCompletionBlock {
            var finished = true
            for la in animations {
                finished = la.animation.finished && finished
            }
            AnimationDelagate.groupDidStop(completion!, finished:finished)
        }
    }
    var duration:CFTimeInterval = 0
    for la in animations {
        la.apply()
        duration = max(duration, la.animation.duration)
        la.animation.finished = true    // create delegate
    }
    CATransaction.setAnimationDuration(duration)
    CATransaction.commit()
}

// MARK: Pair of layer and animation

public class AnimationPair {
    public let layer:CALayer
    public let animation:CAAnimation
    public var key:String
    
    init(_ layer:CALayer, _ animation:CAAnimation, key:String) {
        self.layer = layer
        self.animation = animation
        self.key = key
    }
    
    public func set(did:(CAAnimation) -> Void) -> AnimationPair {
        did(self.animation)
        return self
    }
    
    public func setStop(didStop:() -> Void) -> AnimationPair {
        animation.didStop = didStop
        return self
    }
    
    public func setKey(key:String) -> AnimationPair {
        self.key = key
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
    
    public func setBeginTime(index:Int, gap:CFTimeInterval) -> AnimationPair {
        animation.beginTime = CACurrentMediaTime() + Double(index) * gap
        return self
    }
    
    public func setBeginTime(index:Int, gap:CFTimeInterval, duration:CFTimeInterval) -> AnimationPair {
        animation.beginTime = CACurrentMediaTime() + Double(index) * gap
        setDuration(duration)
        return self
    }
    
    public func apply() {
        if !CAAnimation.isStopping {
            layer.addAnimation(animation, forKey:key)
            if let gradientLayer = layer.gradientLayer {
                gradientLayer.addAnimation(animation, forKey:key)
            }
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
