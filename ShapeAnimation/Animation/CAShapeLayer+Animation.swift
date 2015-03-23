//
//  CAShapeLayer+Animation.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/20.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

public extension CAShapeLayer {
    
    func strokeStartAnimation(from:CGFloat? = nil, to:CGFloat = 1, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"strokeStart")
        animation.duration = 0.8
        animation.fromValue = from
        animation.toValue = to
        setDefaultProperties(animation, 0, didStop)
        if from != nil {
            animation.fillMode = kCAFillModeRemoved
        }
        animation.willStop = {
            withDisableActions(self, animation, animation.keyPath) { layer in
                if let layer = layer as? CAShapeLayer {
                    layer.strokeStart = to
                }
            }
        }
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.didStop = didStop
        return AnimationPair(self, animation)
    }
    
    func strokeEndAnimation(from:CGFloat? = nil, to:CGFloat = 1, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"strokeEnd")
        animation.duration = 0.8
        animation.fromValue = from
        animation.toValue = to
        setDefaultProperties(animation, 0, didStop)
        if from != nil {
            animation.fillMode = kCAFillModeRemoved
        }
        animation.willStop = {
            withDisableActions(self, animation, animation.keyPath) { layer in
                if let layer = layer as? CAShapeLayer {
                    layer.strokeEnd = to
                }
            }
        }
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.didStop = didStop
        return AnimationPair(self, animation)
    }
    
    func strokeColorAnimation(from:CGColor? = nil, to:CGColor, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"strokeColor")
        animation.fromValue = from
        animation.toValue = to
        setDefaultProperties(animation, strokeColor, didStop)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.willStop = {
            withDisableActions(self, animation, animation.keyPath) { layer in
                if let layer = layer as? CAShapeLayer {
                    layer.strokeColor = to
                }
            }
        }
        return AnimationPair(self, animation)
    }
    
    func fillColorAnimation(from:CGColor? = nil, to:CGColor, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"fillColor")
        animation.fromValue = from
        animation.toValue = to
        setDefaultProperties(animation, fillColor, didStop)
        animation.willStop = {
            withDisableActions(self, animation, animation.keyPath) { layer in
                if let layer = layer as? CAShapeLayer {
                    layer.fillColor = to
                }
            }
        }
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        return AnimationPair(self, animation)
    }
    
    func lineWidthAnimation(from:CGFloat? = nil, to:CGFloat, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"lineWidth")
        animation.fromValue = from
        animation.toValue = to
        setDefaultProperties(animation, lineWidth, didStop)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.willStop = {
            withDisableActions(self, animation, animation.keyPath) { layer in
                if let layer = layer as? CAShapeLayer {
                    layer.lineWidth = to
                }
            }
        }
        return AnimationPair(self, animation)
    }
    
    func dashPhaseAnimation(from:CGFloat? = nil, to:CGFloat) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"lineDashPhase")
        animation.fromValue = from
        animation.toValue = to
        setDefaultProperties(animation, lineDashPhase, nil)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
        return AnimationPair(self, animation)
    }
    
    func switchPathAnimation(to:CGPath, didStop:(() -> Void)? = nil) -> AnimationPair {
        let animation = CABasicAnimation(keyPath:"path")
        animation.toValue = to
        setDefaultProperties(animation, path, didStop)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animation.willStop = {
            withDisableActions(self, animation, animation.keyPath) { layer in
                if let layer = layer as? CAShapeLayer {
                    let box = to.boundingBox, frame = self.frame
                    layer.path = to
                    layer.frame = CGRect(x:frame.origin.x, y:frame.origin.y, w:box.maxX, h:box.maxY)
                    layer.apply(layer.gradient)
                }
            }
        }
        return AnimationPair(self, animation)
    }
}
