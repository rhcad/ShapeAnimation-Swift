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
    
    func opacityAnimation(#from:Float, to:Float, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"opacity")
        animation.duration = 0.8
        animation.fromValue = from
        animation.toValue = to
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.didStop = didStop
        animation.willStop = {
            withDisableActions(self, animation) {
                self.opacity = to
            }
            self.removeAnimationForKey("opacity")
        }
        return AnimationPair(self, animation, key:"opacity")
    }
    
    func flashAnimation(repeatCount n:Float = 2, didStop:(() -> Void)? = nil) -> AnimationPair {
        let anim = opacityAnimation(from:0, to:1, didStop:didStop)
        return anim.set {
            $0.repeatCount = n
            $0.autoreverses = true
            $0.removedOnCompletion = true
            $0.duration = 0.2
        }
    }
    
    func scaleAnimation(#from:Float, to:Float, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"transform.scale")
        animation.duration = 0.8
        animation.fromValue = from
        animation.toValue = to
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.didStop = didStop
        animation.willStop = {
            withDisableActions(self, animation) {
                let xf = CGAffineTransform(scale:CGFloat(to))
                self.setAffineTransform(self.affineTransform() + xf)
            }
            self.removeAnimationForKey("scale")
        }
        return AnimationPair(self, animation, key:"scale")
    }
    
    func scaleAnimation(#from:Float, to:Float, repeatCount:Float, didStop:(() -> Void)? = nil) -> AnimationPair {
        return scaleAnimation(from:from, to:to, didStop:didStop).set {
            $0.repeatCount=repeatCount
            $0.autoreverses = repeatCount > 1
            $0.fillMode = kCAFillModeRemoved
        }
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
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.didStop = didStop
        animation.willStop = {
            withDisableActions(self, animation) {
                let xf = CGAffineTransform(rotation:angle)
                self.setAffineTransform(self.affineTransform() + xf)
            }
            self.removeAnimationForKey("rotation")
        }
        return AnimationPair(self, animation, key:"rotation")
    }
    
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
    
    func moveAnimation(#to:CGPoint, relative:Bool = true) -> AnimationPair {
        return moveAnimation(from:relative ? CGPoint.zeroPoint : position, to:to, relative:relative)
    }
    
    func moveAnimation(#from:CGPoint, to:CGPoint, relative:Bool = true, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"position")
        animation.duration = 0.3
        animation.additive = relative
        animation.fromValue = NSValue(CGPoint: from)
        animation.toValue = NSValue(CGPoint: to)
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        animation.didStop = didStop
        animation.willStop = {
            withDisableActions(self, animation) {
                self.position = relative ? self.position + to : to
            }
            self.removeAnimationForKey("move")
        }
        return AnimationPair(self, animation, key:"move")
    }
    
    func moveOnPathAnimation(path:CGPath, autoRotate:Bool = false, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.path = path
        animation.duration = 0.8
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        if autoRotate {
            animation.rotationMode = kCAAnimationRotateAuto
        }
        animation.didStop = didStop
        animation.willStop = {
            self.removeAnimationForKey("moveOnPath")
            withDisableActions(self, animation) {
                self.position = path.endPoint
                if autoRotate {
                    let xf = CGAffineTransform(rotation:path.endTangent.direction)
                    self.setAffineTransform(self.affineTransform() + xf)
                }
            }
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
        return AnimationPair(self, slide, key:"slide")
    }
    
}
