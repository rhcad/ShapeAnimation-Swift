//
//  Gradient.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/29.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import QuartzCore
import SwiftGraphics

private var GradientInfoKey = 11
private var GradientLayerKey = 12

public extension CAShapeLayer {
    public var gradient: Gradient? {
        get {
            return getAssociatedObject(self, &GradientInfoKey) as Gradient?
        }
        set {
            setAssociatedObject(self, &GradientInfoKey, newValue)
            apply(newValue)
        }
    }
    
    public func apply(newStyle:Gradient?) {
        if newStyle?.colors != nil && path.isClosed {
            let style = newStyle!
            let gradientLayer = CAGradientLayer()
            let maskLayer = CAShapeLayer()
            
            maskLayer.frame = self.bounds
            maskLayer.path = self.path
            maskLayer.strokeColor = nil
            
            gradientLayer.colors = style.colors!
            gradientLayer.locations = style.locations
            if let orientation = style.orientation {
                gradientLayer.startPoint = orientation.0
                gradientLayer.endPoint = orientation.1
            }
            if style.axial {
                gradientLayer.type = kCAGradientLayerAxial
            }
            gradientLayer.frame = frame
            gradientLayer.mask = maskLayer
            
            self.superlayer.addSublayer(gradientLayer)
            self.fillColor = nil
            self.gradientLayer = gradientLayer
        } else {
            self.gradientLayer = nil
        }
    }
}

public extension CALayer {
    
    public var gradientLayer: CAGradientLayer? {
        get {
            let defv:CAGradientLayer? = nil
            return getAssociatedObject(self, &GradientLayerKey, defv)
        }
        set {
            weak var layer = newValue
            setAssociatedObject(self, &GradientLayerKey, layer)
        }
    }
}
