//
//  CAShapeLayer+Animation.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/20.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

public extension CAShapeLayer {
    
    func strokeStartAnimation(from:CGFloat? = 0, to:CGFloat = 1, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"strokeStart")
        animation.duration = 0.8
        animation.fromValue = from
        animation.toValue = to
        setDefaultProperties(animation, 0, didStop)
        if from != nil {
            animation.fillMode = kCAFillModeRemoved
        }
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.didStop = didStop
        return AnimationPair(self, animation, key:animation.keyPath)
    }
    
    func strokeEndAnimation(from:CGFloat? = 0, to:CGFloat = 1, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"strokeEnd")
        animation.duration = 0.8
        animation.fromValue = from
        animation.toValue = to
        setDefaultProperties(animation, 0, didStop)
        if from != nil {
            animation.fillMode = kCAFillModeRemoved
        }
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.didStop = didStop
        return AnimationPair(self, animation, key:animation.keyPath)
    }
    
    func strokeColorAnimation(from:CGColor? = nil, to:CGColor, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"strokeColor")
        animation.fromValue = from
        animation.toValue = to
        setDefaultProperties(animation, strokeColor, didStop)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.willStop = {
            withDisableActions(self, animation) {
                self.strokeColor = to
            }
            self.removeAnimationForKey(animation.keyPath)
        }
        return AnimationPair(self, animation, key:animation.keyPath)
    }
    
    func fillColorAnimation(from:CGColor? = nil, to:CGColor, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"fillColor")
        animation.fromValue = from
        animation.toValue = to
        setDefaultProperties(animation, fillColor, didStop)
        animation.willStop = {
            withDisableActions(self, animation) {
                self.fillColor = to
            }
            self.removeAnimationForKey(animation.keyPath)
        }
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        return AnimationPair(self, animation, key:animation.keyPath)
    }
    
    func backColorAnimation(from:CGColor? = nil, to:CGColor, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"backgroundColor")
        animation.fromValue = from
        animation.toValue = to
        setDefaultProperties(animation, backgroundColor, didStop)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.willStop = {
            withDisableActions(self, animation) {
                self.backgroundColor = to
            }
            self.removeAnimationForKey(animation.keyPath)
        }
        return AnimationPair(self, animation, key:animation.keyPath)
    }
    
    func lineWidthAnimation(from:CGFloat? = nil, to:CGFloat, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"lineWidth")
        animation.fromValue = from
        animation.toValue = to
        setDefaultProperties(animation, lineWidth, didStop)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.willStop = {
            withDisableActions(self, animation) {
                self.lineWidth = to
            }
            self.removeAnimationForKey(animation.keyPath)
        }
        return AnimationPair(self, animation, key:animation.keyPath)
    }
    
    func dashPhaseAnimation(from:CGFloat? = nil, to:CGFloat) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"lineDashPhase")
        animation.fromValue = from
        animation.toValue = to
        setDefaultProperties(animation, lineDashPhase, nil)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
        return AnimationPair(self, animation, key:animation.keyPath)
    }
    
    func switchPathAnimation(to:CGPath, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"path")
        animation.toValue = path
        setDefaultProperties(animation, path, didStop)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.willStop = {
            withDisableActions(self, animation) {
                self.path = to
            }
            self.removeAnimationForKey(animation.keyPath)
        }
        return AnimationPair(self, animation, key:animation.keyPath)
    }
}
