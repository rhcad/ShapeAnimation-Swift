//
//  AnimationPair.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/20.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

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
    public let key:String
    
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
    
    public func setBeginTime(gap:CFTimeInterval) -> AnimationPair {
        return setBeginTime(1, gap:gap)
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
            if let gradientLayer = layer.gradientLayer {
                let anim2 = animation.copy() as CAAnimation
                anim2.delegate = AnimationDelagate()
                if let layerid = layer.identifier {
                    anim2.setValue(layerid + "_gradient", forKey:"layerID")
                }
                gradientLayer.addAnimation(anim2, forKey:key)
            }
            animation.setValue(layer.identifier, forKey:"layerID")
            layer.addAnimation(animation, forKey:key)
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

// MARK: setAnchorPoint just change anchorPoint, and not change position

public extension CALayer {
    public func setAnchorPoint(point:CGPoint, fromLayer:CALayer? = nil) {
        let oldframe = self.frame
        if let fromLayer = fromLayer {
            let pt = convertPoint(point, fromLayer:fromLayer) / bounds.size
            self.anchorPoint = pt
        } else {
            self.anchorPoint = point
        }
        self.frame = oldframe
    }
}

public extension AnimationPair {
    public func setAnchorPoint(point:CGPoint, fromLayer:CALayer? = nil) -> AnimationPair {
        layer.setAnchorPoint(point, fromLayer:fromLayer)
        return self
    }
}

// MARK: withDisableActions

public func withDisableActions(block:() -> Void) {
    let old = CATransaction.disableActions()
    CATransaction.setDisableActions(true)
    block()
    CATransaction.setDisableActions(old)
}

public func withDisableActions(layer:CALayer, animation:CAAnimation, block:() -> Void) {
    let forwards = animation.fillMode == kCAFillModeForwards || animation.fillMode == kCAFillModeBoth
    if !animation.autoreverses && forwards {
        withDisableActions(block)
    }
}
