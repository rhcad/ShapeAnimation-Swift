//
//  CALayer+Slide.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 2/10/15.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

public extension CALayer {
    
    // MARK: Slide animations
    
    func slideToRight(didStop:(() -> Void)? = nil) -> AnimationPair {
        return slideAnimation(kCATransitionFromLeft, didStop:didStop)
    }
    
    func slideAnimation(subtype:String, didStop:(() -> Void)? = nil) -> AnimationPair {
        let slide = CATransition()
        
        slide.type = kCATransitionPush
        slide.subtype = subtype
        slide.duration = 0.8
        slide.didStop = didStop
        slide.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return AnimationPair(self, slide, key:"slide")
    }

    // MARK: Flip animations
    
    func flipHorizontally(didStop:(() -> Void)? = nil) -> AnimationPair {
        return flipAnimation(x:0, y:1, didStop:didStop)
    }
    
    func flipVertically(didStop:(() -> Void)? = nil) -> AnimationPair {
        return flipAnimation(x:1, y:0, didStop:didStop)
    }
    
    private func flipAnimation(#x:CGFloat, y:CGFloat, didStop:(() -> Void)? = nil) -> AnimationPair {
        var xf = CATransform3DIdentity
        xf.m34 = 1.0 / -500
        xf = CATransform3DRotate(xf, CGFloat(M_PI), x, y, 0.0)
        
        let animation = CABasicAnimation(keyPath:"transform")
        animation.additive = true
        animation.fromValue = NSValue(CATransform3D:CATransform3DIdentity)
        animation.toValue = NSValue(CATransform3D:xf)
        setDefaultProperties(animation, NSNull(), didStop)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.willStop = {
            withDisableActions(self, animation, "flip") { layer in
                layer.transform = CATransform3DConcat(xf, layer.transform)
            }
        }
        return AnimationPair(self, animation, key:"flip")
    }
    
    // MARK: transform animation
    
    func transformAnimation(from:CATransform3D? = nil, to:CATransform3D, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"transform")
        if let from = from {
            animation.fromValue = NSValue(CATransform3D:from)
        }
        animation.toValue = NSValue(CATransform3D:to)
        setDefaultProperties(animation, NSValue(CATransform3D:CATransform3DIdentity), didStop)
        animation.willStop = {
            withDisableActions(self, animation, animation.keyPath) { layer in
                layer.transform = to
            }
        }
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        return AnimationPair(self, animation, key:animation.keyPath)
    }
}
