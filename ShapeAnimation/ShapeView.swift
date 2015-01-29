//
//  ShapeView.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/20.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import UIKit
import QuartzCore
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
    
    public func addShapeLayer(path:CGPath) -> CAShapeLayer {
        let frame = path.boundingBox
        var xf    = CGAffineTransform(translation:-frame.origin)
        let layer = CAShapeLayer()
        
        layer.frame = frame
        layer.path = frame.isEmpty ? path : CGPathCreateCopyByTransformingPath(path, &xf)
        self.layer.addSublayer(layer)
        layer.apply(style)
        layer.apply(gradient)
        
        return layer
    }
    
    public func addTextLayer(text:String, frame:CGRect, fontSize:CGFloat) -> CATextLayer {
        let layer = CATextLayer()
        
        layer.frame = frame
        layer.string = text
        layer.fontSize = fontSize
        if let strokeColor = style.strokeColor {
            layer.foregroundColor = strokeColor
        }
        layer.alignmentMode = kCAAlignmentCenter
        layer.wrapped = true
        self.layer.addSublayer(layer)
    
        return layer
    }
    
    public func addImageLayer(image:UIImage!, center:CGPoint) -> CALayer {
        let layer = CALayer()
        layer.contents = image.CGImage
        layer.frame = CGRect(center:center, size:image.size)
        self.layer.addSublayer(layer)
        return layer
    }
    
    override public func removeFromSuperview() {
        if self.layer.sublayers != nil {
            for layer in self.layer.sublayers {
                layer.removeLayer()
            }
        }
        super.removeFromSuperview()
    }
}

public extension CALayer {
    
    public func removeLayer() {
        gradientLayer = nil
        self.removeFromSuperlayer()
    }
}

public extension ShapeView {
    
    public func addCircleLayer(center c:CGPoint, radius:CGFloat) -> CAShapeLayer {
        return addShapeLayer(CGPathCreateWithEllipseInRect(CGRect(center:c, radius:radius), nil))
    }
    
    public func addPolygonLayer(nside:Int, center:CGPoint, radius:CGFloat) -> CAShapeLayer {
        return addLinesLayer(RegularPolygon(nside:nside, center:center, radius:radius).points, closed:true)
    }
    
    public func addLinesLayer(points:[CGPoint], closed:Bool = false) -> CAShapeLayer {
        return addShapeLayer(Path(vertices:points, closed:closed).cgPath)
    }
    
}

public extension CAShapeLayer {
    
    //! The path used to create this layer initially and mapped to the parent layer's coordinate systems.
    public var transformedPath:CGPath {
        get {
            var xf = CGAffineTransform(translation:frame.origin)
            return CGPathCreateCopyByTransformingPath(path, &xf)
        }
        set(v) {
            frame = v.boundingBox
            var xf = CGAffineTransform(translation:-frame.origin)
            path = CGPathCreateCopyByTransformingPath(v, &xf)
        }
    }
    
}
