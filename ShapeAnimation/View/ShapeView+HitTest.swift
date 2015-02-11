//
//  ShapeView+HitTest.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 2/8/15.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

public extension CALayer {
    public func enumerateLayers(block:(CALayer) -> Void) {
        if let sublayers = self.sublayers {
            for layer in sublayers {
                block(layer as CALayer)
            }
        }
    }
}

public extension ShapeView {
    
    public func enumerateLayers(block:(CALayer) -> Void) {
        self.layer.enumerateLayers(block)
    }
    
    public func hitTest(point:CGPoint) -> CALayer? {
        var ret:CALayer?
        var minFrame:CGRect!
        func area(rect:CGRect) -> CGFloat { return rect.width * rect.height }
        
        enumerateLayers { layer in
            if let shape = layer as? CAShapeLayer {
                if shape.frame.contains(point) && shape.hitTestPath(point) {
                    if ret == nil || shape.isFilled || area(shape.frame) < area(minFrame) {
                        ret = shape
                        minFrame = shape.frame
                    }
                }
            }
            else if layer.frame.contains(point) {
                ret = layer
                minFrame = layer.frame
            }
        }
        return ret
    }
    
    public func intersects(rect:CGRect) -> [CALayer] {
        var ret:[CALayer] = []
        
        enumerateLayers { layer in
            if let shape = layer as? CAShapeLayer {
                if shape.intersects(rect) {
                    ret.append(shape)
                }
            }
            else if layer.frame.contains(rect) {
                ret.append(layer)
            }
        }
        return ret
    }
}

public extension CAShapeLayer {
    
    public var isFilled : Bool {
        return path.isClosed && (paintStyle.fillColor != nil || gradient?.colors != nil)
    }
    
    public func hitTestPath(point:CGPoint) -> Bool {
        var xf = affineTransform().inverted() + CGAffineTransform(translation: -position)
        return CGPathContainsPoint(self.path, &xf, point, false)
    }
    
    public func intersects(rect:CGRect) -> Bool {
        var xf = affineTransform().inverted() + CGAffineTransform(translation: -position)
        return self.path.intersects(rect * xf)
    }
}
