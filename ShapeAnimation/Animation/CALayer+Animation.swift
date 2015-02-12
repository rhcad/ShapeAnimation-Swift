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
    
    // MARK: opacityAnimation and flashAnimation
    
    func opacityAnimation(#from:CGFloat?, to:CGFloat, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"opacity")
        animation.fromValue = from
        animation.toValue = to
        setDefaultProperties(animation, 0, didStop)
        animation.willStop = {
            withDisableActions(self, animation) {
                self.opacity = Float(to)
            }
            self.removeAnimationForKey(animation.keyPath)
        }
        return AnimationPair(self, animation, key:animation.keyPath)
    }
    
    func flashAnimation(repeatCount n:Float = 2, didStop:(() -> Void)? = nil) -> AnimationPair {
        let apair = opacityAnimation(from:0, to:1, didStop:didStop)
        return apair.autoreverses().setRepeatCount(n).setDuration(0.2)
    }
    
    // MARK: scaleAnimation and tapAnimation
    
    func scaleAnimation(#from:CGFloat?, to:CGFloat, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"transform.scale")
        let oldxf = affineTransform(), oldscale = hypot(oldxf.a, oldxf.b)
        
        if let from = from {
            animation.fromValue = from * oldscale
        }
        animation.toValue = to * oldscale
        setDefaultProperties(animation, 1, didStop)
        animation.willStop = {
            withDisableActions(self, animation) {
                let xf = CGAffineTransform(scale:to)
                self.setAffineTransform(self.affineTransform() + xf)
            }
            self.removeAnimationForKey(animation.keyPath)
        }
        return AnimationPair(self, animation, key:animation.keyPath)
    }
    
    func scaleAnimation(#from:CGFloat?, to:CGFloat, repeatCount n:Float, didStop:(() -> Void)? = nil) -> AnimationPair {
        return scaleAnimation(from:from, to:to, didStop:didStop)
            .setRepeatCount(n).setFillMode(kCAFillModeRemoved).set { $0.autoreverses = n > 1 }
    }
    
    func tapAnimation(didStop:(() -> Void)? = nil) -> AnimationPair {
        return scaleAnimation(from:1, to:1.25, didStop:didStop).autoreverses().set {$0.duration=0.3}
    }
    
    // MARK: rotate360Degrees and rotationAnimation
    
    func rotate360Degrees(didStop:(() -> Void)? = nil) -> AnimationPair {
        return rotationAnimation(CGFloat(2 * M_PI), didStop:didStop)
    }
    
    func rotationAnimation(angle:Radians, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"transform.rotation")
        animation.additive = true
        animation.fromValue = 0.0
        animation.toValue = angle
        setDefaultProperties(animation, 0, didStop)
        animation.willStop = {
            withDisableActions(self, animation) {
                let xf = CGAffineTransform(rotation:angle)
                self.setAffineTransform(self.affineTransform() + xf)
            }
            self.removeAnimationForKey(animation.keyPath)
        }
        return AnimationPair(self, animation, key:animation.keyPath)
    }
    
    // MARK: shakeAnimation, moveAnimation and moveOnPathAnimation
    
    func shakeAnimation(didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, 0]
        animation.duration = 0.8
        animation.additive = true
        animation.didStop = didStop
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        return AnimationPair(self, animation, key:"shake")
    }
    
    func moveAnimation(from:CGPoint? = nil, to:CGPoint, relative:Bool = true, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"position")
        animation.additive = relative
        if let from = from {
            animation.fromValue = NSValue(CGPoint: from)
        }
        animation.toValue = NSValue(CGPoint: to)
        setDefaultProperties(animation, NSNull(), didStop)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        animation.willStop = {
            withDisableActions(self, animation) {
                self.position = relative ? self.position + to : to
            }
            self.removeAnimationForKey(animation.keyPath)
        }
        return AnimationPair(self, animation, key:animation.keyPath)
    }
    
    func moveOnPathAnimation(path:CGPath, autoRotate:Bool = false, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.path = path
        setDefaultProperties(animation, NSNull(), didStop)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        if autoRotate {
            animation.rotationMode = kCAAnimationRotateAuto
        }
        animation.willStop = {
            self.removeAnimationForKey(animation.keyPath)
            withDisableActions(self, animation) {
                self.position = path.endPoint
                if autoRotate {
                    let xf = CGAffineTransform(rotation:path.endTangent.direction)
                    self.setAffineTransform(self.affineTransform() + xf)
                }
            }
        }
        return AnimationPair(self, animation, key:animation.keyPath)
    }
    
    internal func setDefaultProperties(animation:CAAnimation, _ defaultFromValue:AnyObject, didStop:(() -> Void)?) {
        animation.duration = 0.8
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.didStop = didStop
        if let basic = animation as? CABasicAnimation {
            if basic.fromValue == nil {
                if let presentation = self.presentationLayer() as? CALayer {
                    basic.fromValue = presentation.valueForKeyPath(basic.keyPath)
                } else {
                    basic.fromValue = defaultFromValue
                }
            }
        }
    }
}
