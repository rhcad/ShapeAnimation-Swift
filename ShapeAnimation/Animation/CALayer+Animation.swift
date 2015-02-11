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
    
    func opacityAnimation(#from:Float, to:Float, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"opacity")
        setDefaultProperties(animation, didStop)
        animation.fromValue = from
        animation.toValue = to
        animation.willStop = {
            withDisableActions(self, animation) {
                self.opacity = to
            }
            self.removeAnimationForKey("opacity")
        }
        return AnimationPair(self, animation, key:"opacity")
    }
    
    func flashAnimation(repeatCount n:Float = 2, didStop:(() -> Void)? = nil) -> AnimationPair {
        let apair = opacityAnimation(from:0, to:1, didStop:didStop)
        return apair.autoreverses().setRepeatCount(n).setDuration(0.2)
    }
    
    // MARK: scaleAnimation and tapAnimation
    
    func scaleAnimation(#from:Float, to:Float, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"transform.scale")
        let oldxf = affineTransform(), oldscale = Float(hypot(oldxf.a, oldxf.b))
        
        setDefaultProperties(animation, didStop)
        animation.fromValue = from * oldscale
        animation.toValue = to * oldscale
        animation.willStop = {
            withDisableActions(self, animation) {
                let xf = CGAffineTransform(scale:CGFloat(to))
                self.setAffineTransform(self.affineTransform() + xf)
            }
            self.removeAnimationForKey("scale")
        }
        return AnimationPair(self, animation, key:"scale")
    }
    
    func scaleAnimation(#from:Float, to:Float, repeatCount n:Float, didStop:(() -> Void)? = nil) -> AnimationPair {
        return scaleAnimation(from:from, to:to, didStop:didStop).setRepeatCount(n).set { anim in
            anim.autoreverses = n > 1
            anim.fillMode = kCAFillModeRemoved
        }
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
        setDefaultProperties(animation, didStop)
        animation.additive = true
        animation.fromValue = 0.0
        animation.toValue = angle
        animation.willStop = {
            withDisableActions(self, animation) {
                let xf = CGAffineTransform(rotation:angle)
                self.setAffineTransform(self.affineTransform() + xf)
            }
            self.removeAnimationForKey("rotation")
        }
        return AnimationPair(self, animation, key:"rotation")
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
    
    func moveAnimation(#to:CGPoint, relative:Bool = true) -> AnimationPair {
        return moveAnimation(from:relative ? CGPoint.zeroPoint : position, to:to, relative:relative)
    }
    
    func moveAnimation(#from:CGPoint, to:CGPoint, relative:Bool = true, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"position")
        setDefaultProperties(animation, didStop)
        animation.additive = relative
        animation.fromValue = NSValue(CGPoint: from)
        animation.toValue = NSValue(CGPoint: to)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
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
        setDefaultProperties(animation, didStop)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        if autoRotate {
            animation.rotationMode = kCAAnimationRotateAuto
        }
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
    
}

internal func setDefaultProperties(animation:CAAnimation, didStop:(() -> Void)?) {
    animation.duration = 0.8
    animation.removedOnCompletion = false
    animation.fillMode = kCAFillModeForwards
    animation.didStop = didStop
}
