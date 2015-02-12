//
//  ShapeView.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/20.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

//! View class which contains vector shape layers.
public class ShapeView : UIView {
    
    public var style:PaintStyle = {
        var style = PaintStyle.defaultStyle
        style.lineCap = kCGLineCapButt
        style.lineJoin = kCGLineJoinRound
        return style
        }()
    public var gradient = Gradient()
    
    public func addSublayer(layer:CALayer, frame:CGRect, superlayer:CALayer? = nil) {
        layer.frame = frame
        layer.contentsScale = UIScreen.mainScreen().scale
        if let superlayer = superlayer {
            superlayer.addSublayer(layer)
        } else {
            self.layer.addSublayer(layer)
        }
    }
    
    public func addShapeLayer(path:CGPath, superlayer:CALayer? = nil) -> CAShapeLayer! {
        return addShapeLayer(path, position:nil, superlayer:superlayer)
    }
    
    public func addShapeLayer(path:CGPath, center:CGPoint, superlayer:CALayer? = nil) -> CAShapeLayer! {
        return addShapeLayer(path, position:center - CGPoint(size:path.boundingBox.size / 2), superlayer:superlayer)
    }
    
    public func addShapeLayer(path:CGPath, position:CGPoint?, superlayer:CALayer? = nil) -> CAShapeLayer! {
        let box   = path.boundingBox
        let size  = CGSize(w: max(box.width, 1), h: max(box.height, 1))
        let frame = CGRect(origin:position != nil ? position! : box.origin, size:size)
        var xf    = CGAffineTransform(translation:-box.origin)
        let layer = CAShapeLayer()
        
        layer.path = box.isNull || position != nil ? path : CGPathCreateCopyByTransformingPath(path, &xf)
        self.addSublayer(layer, frame:frame, superlayer:superlayer)
        layer.apply(style)
        layer.apply(gradient)
        
        return layer
    }
    
    // MARK: override from UIView
    
    override public func removeFromSuperview() {
        enumerateLayers { $0.removeLayer() }
        super.removeFromSuperview()
    }
    
    private var lastBounds = CGRect.zeroRect
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        lastBounds = self.layer.bounds
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if lastBounds != bounds {
            enumerateLayers { layer in
                if layer.frame == self.lastBounds {
                    layer.frame = self.bounds
                }
            }
            lastBounds = self.bounds
        }
    }
}

// MARK: CALayer.removeLayer

public extension CALayer {
    
    public func removeLayer() {
        gradientLayer = nil
        self.removeAllAnimations()
        self.removeFromSuperlayer()
    }
}
