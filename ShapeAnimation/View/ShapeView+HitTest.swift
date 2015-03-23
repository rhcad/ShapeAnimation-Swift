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
        if let sublayers = sublayers {
            for layer in sublayers {
                if !layer.isKindOfClass(CAGradientLayer) {
                    block(layer as! CALayer)
                }
            }
        }
    }
}

public extension ShapeView {
    
    public func enumerateLayers(block:(CALayer) -> Void) {
        sublayer.enumerateLayers(block)
    }
    
    public func hitTest(point:CGPoint, filter:((CALayer) -> Bool)? = nil) -> CALayer? {
        var ret:CALayer?
        var defaultShape:CALayer?
        var minFrame:CGRect!
        func area(rect:CGRect) -> CGFloat { return rect.width * rect.height }
        
        enumerateLayers { layer in
            if layer.frame.contains(point) && (filter == nil || filter!(layer)) {
                defaultShape = layer
                if let shape = layer as? CAShapeLayer {
                    if shape.hitTestPath(point) {
                        if ret == nil || area(shape.frame) < area(minFrame) {
                            ret = shape
                            minFrame = shape.frame
                        }
                    }
                }
                else {
                    ret = layer
                    minFrame = layer.frame
                }
            }
        }
        return ret != nil ? ret : defaultShape
    }
    
    public func intersects(rect:CGRect, filter:((CALayer) -> Bool)? = nil) -> [CALayer] {
        var ret:[CALayer] = []
        
        enumerateLayers { layer in
            if let shape = layer as? CAShapeLayer {
                if shape.intersects(rect) && (filter == nil || filter!(shape)) {
                    ret.append(shape)
                }
            }
            else if layer.frame.contains(rect) && (filter == nil || filter!(layer)) {
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
        let path = isFilled ? self.path : strokingPath(max(lineWidth, 10))
        var xf = affineTransform().inverted() + CGAffineTransform(translation: -position)
        return CGPathContainsPoint(path, &xf, point, false)
    }
    
    public func intersects(rect:CGRect) -> Bool {
        var xf = affineTransform().inverted() + CGAffineTransform(translation: -position)
        return path.intersects(rect * xf)
    }
}
