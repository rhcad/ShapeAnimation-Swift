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
    
    public func addSublayer(layer:CALayer, frame:CGRect) {
        layer.frame = frame
        layer.contentsScale = UIScreen.mainScreen().scale
        self.layer.addSublayer(layer)
    }
    
    public func addShapeLayer(path:CGPath) -> CAShapeLayer {
        let frame = path.boundingBox
        var xf    = CGAffineTransform(translation:-frame.origin)
        let layer = CAShapeLayer()
        
        layer.path = frame.isEmpty ? path : CGPathCreateCopyByTransformingPath(path, &xf)
        self.addSublayer(layer, frame:frame)
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
            enumerateLayers {
                if $0.frame == self.lastBounds {
                    $0.frame = self.bounds
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
