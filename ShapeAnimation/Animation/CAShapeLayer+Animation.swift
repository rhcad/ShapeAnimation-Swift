//
//  CAShapeLayer+Animation.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/20.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

public extension CAShapeLayer {
    
    func strokeEndAnimation(from:Float = 0, to:Float = 1, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"strokeEnd")
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.didStop = didStop
        return AnimationPair(self, animation, key:"strokeEnd")
    }
    
    func strokeColorAnimation(#from:CGColor, to:CGColor, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"strokeColor")
        setDefaultProperties(animation, didStop)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = from
        animation.toValue = to
        animation.willStop = {
            withDisableActions(self, animation) {
                self.strokeColor = to
            }
            self.removeAnimationForKey("strokeColor")
        }
        return AnimationPair(self, animation, key:"strokeColor")
    }
    
    func fillColorAnimation(#from:CGColor, to:CGColor, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"fillColor")
        setDefaultProperties(animation, didStop)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = from
        animation.toValue = to
        animation.willStop = {
            withDisableActions(self, animation) {
                self.fillColor = to
            }
            self.removeAnimationForKey("fillColor")
        }
        return AnimationPair(self, animation, key:"fillColor")
    }
    
    func lineWidthAnimation(#from:CGFloat, to:CGFloat, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"lineWidth")
        setDefaultProperties(animation, didStop)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = from
        animation.toValue = to
        animation.willStop = {
            withDisableActions(self, animation) {
                self.lineWidth = to
            }
            self.removeAnimationForKey("lineWidth")
        }
        return AnimationPair(self, animation, key:"lineWidth")
    }
    
    func dashPhaseAnimation(#from:CGFloat, to:CGFloat) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"lineDashPhase")
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
        animation.fromValue = from
        animation.toValue = to
        return AnimationPair(self, animation, key:"dashPhase")
    }
    
    func switchPathAnimation(to:CGPath, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"path")
        setDefaultProperties(animation, didStop)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.toValue = path
        animation.willStop = {
            withDisableActions(self, animation) {
                self.path = to
            }
            self.removeAnimationForKey("path")
        }
        return AnimationPair(self, animation, key:"path")
    }
}
