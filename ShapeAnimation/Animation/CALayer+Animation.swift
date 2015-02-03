//
//  CALayer+Animation.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/20.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

public extension CALayer {
    typealias Radians = CGFloat
    typealias RelativePoint = CGPoint
    
    func opacityAnimation(#from:Float, to:Float, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"opacity")
        animation.duration = 0.8
        animation.fromValue = from
        animation.toValue = to
        animation.didStop = didStop
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        return AnimationPair(self, animation, key:"opacity")
    }
    
    func flashAnimation(repeatCount n:Float = 2, didStop:(() -> Void)? = nil) -> AnimationPair {
        let anim = opacityAnimation(from:0, to:1, didStop:didStop)
        anim.key = "flash"
        return anim.set {
            $0.repeatCount = n
            $0.autoreverses = true
            $0.fillMode = kCAFillModeRemoved
            $0.duration = 0.2
        }
    }
    
    func scaleAnimation(#from:Float, to:Float, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"transform.scale")
        animation.duration = 0.8
        animation.fromValue = from
        animation.toValue = to
        animation.didStop = didStop
        animation.autoreverses = true
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        return AnimationPair(self, animation, key:"scale")
    }
    
    func scaleAnimation(#from:Float, to:Float, repeatCount:Float, didStop:(() -> Void)? = nil) -> AnimationPair {
        return scaleAnimation(from:from, to:to, didStop:didStop).set {$0.repeatCount=repeatCount}
    }
    
    func rotate360Degrees(didStop:(() -> Void)? = nil) -> AnimationPair {
        return rotationAnimation(angle:CGFloat(2 * M_PI), didStop:didStop)
    }
    
    func rotationAnimation(#angle:Radians, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"transform.rotation")
        animation.duration = 0.8
        animation.additive = true
        animation.fromValue = 0.0
        animation.toValue = angle
        animation.didStop = {
            let old = CATransaction.disableActions()
            CATransaction.setDisableActions(true)
            self.setAffineTransform(CGAffineTransform(rotation:angle))
            CATransaction.setDisableActions(old)
            didStop?()
        }
        animation.removedOnCompletion = false
        return AnimationPair(self, animation, key:"rotation")
    }
    
    func shakeAnimation(didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, 0]
        animation.duration = 0.8
        animation.additive = true
        animation.didStop = didStop
        animation.removedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        return AnimationPair(self, animation, key:"shake")
    }
    
    func moveAnimation(#to:RelativePoint) -> AnimationPair {
        return moveAnimation(from:CGPoint.zeroPoint, to:to)
    }
    
    func moveAnimation(#from:RelativePoint, to:RelativePoint, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"position")
        animation.duration = 0.3
        animation.additive = true
        animation.fromValue = NSValue(CGPoint: from)
        animation.toValue = NSValue(CGPoint: to)
        animation.didStop = didStop
        animation.removedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.fillMode = kCAFillModeForwards
        return AnimationPair(self, animation, key:"move")
    }
    
    func moveOnPathAnimation(path:CGPath, autoRotate:Bool = false, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.path = path
        animation.duration = 0.8
        animation.didStop = didStop
        animation.removedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.fillMode = kCAFillModeForwards
        if autoRotate {
            animation.rotationMode = kCAAnimationRotateAuto
        }
        return AnimationPair(self, animation, key:"moveOnPath")
    }
    
    func slideToRight(didStop:(() -> Void)? = nil) -> AnimationPair {
        let slide = CATransition()
        
        slide.type = kCATransitionPush
        slide.subtype = kCATransitionFromLeft
        slide.duration = 0.8
        slide.didStop = didStop
        slide.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slide.fillMode = kCAFillModeRemoved
        return AnimationPair(self, slide, key:"slide")
    }
    
}
