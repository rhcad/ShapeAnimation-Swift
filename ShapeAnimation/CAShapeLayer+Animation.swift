//
//  CAShapeLayer+Animation.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/20.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import UIKit
import QuartzCore
import SwiftGraphics

public extension CAShapeLayer {
    
    func strokeEndAnimation(from:Float = 0, to:Float = 1, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"strokeEnd")
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.didStop = didStop
        animation.removedOnCompletion = false
        return AnimationPair(self, animation, key:"strokeEnd")
    }
    
    func strokeColorAnimation(#from:CGColor, to:CGColor, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"strokeColor")
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = from
        animation.toValue = to
        animation.didStop = didStop
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        return AnimationPair(self, animation, key:"strokeColor")
    }
    
    func lineWidthAnimation(#from:CGFloat, to:CGFloat, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"lineWidth")
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = from
        animation.toValue = to
        animation.didStop = didStop
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        return AnimationPair(self, animation, key:"lineWidth")
    }
    
    func dashPhaseAnimation(#from:CGFloat, to:CGFloat) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"lineDashPhase")
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
        animation.fromValue = from
        animation.toValue = to
        animation.removedOnCompletion = false
        return AnimationPair(self, animation, key:"dashPhase")
    }
    
    func switchPathAnimation(to:CGPath, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"path")
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.toValue = path
        animation.didStop = didStop
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        return AnimationPair(self, animation, key:"path")
    }
}
