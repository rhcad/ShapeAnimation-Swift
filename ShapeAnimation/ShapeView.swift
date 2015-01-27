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

//! Stroke and fill properties for new shape layers
public struct StrokeFill {
    public var strokeColor      = UIColor(white:0, alpha:0.8)
    public var fillColor        : UIColor?
    public var gradientFill     :[(CGFloat, UIColor)]?
    public var gradientOrientation = (CGPoint(x:0.5, y:0), CGPoint(x:0.5, y:1))
    public var strokeWidth      : CGFloat = 2.0
    public var lineCap          = kCALineCapButt
    public var lineJoin         = kCALineJoinRound
    public var lineDash         : [CGFloat]?
    
    public init() {}
    public var gradientColors:[UIColor]? {
        get { return gradientFill?.map{$0.1} }
        set(v) {
            if v != nil && v!.count > 0 {
                var i = 0
                gradientFill = v?.map{ (CGFloat(i++)/CGFloat(v!.count), $0) }
            } else {
                gradientFill = nil
            }
        }
    }
}

//! View class which contains vector shape layers.
public class ShapeView : UIView {
    
    public var style = StrokeFill()
    
    public func addShapeLayer(path:CGPath) -> CAShapeLayer {
        let frame = path.boundingBox
        var xf    = CGAffineTransform(translation:-frame.origin)
        let layer = CAShapeLayer()
        
        layer.frame = frame
        layer.path = frame.isEmpty ? path : CGPathCreateCopyByTransformingPath(path, &xf)
        layer.strokeColor = style.strokeColor.CGColor
        layer.lineWidth = style.strokeWidth
        layer.lineCap = path.isClosed ? kCALineCapRound : style.lineCap
        layer.lineJoin = style.lineJoin
        layer.lineDashPattern = style.lineDash
        
        if style.gradientFill != nil && path.isClosed {
            let gradientLayer = CAGradientLayer()
            let maskLayer = CAShapeLayer()
            
            maskLayer.frame = layer.bounds
            maskLayer.path = layer.path
            maskLayer.strokeColor = nil
            
            gradientLayer.colors = style.gradientFill!.map{$0.1.CGColor}
            gradientLayer.locations = style.gradientFill!.map{$0.0}
            gradientLayer.startPoint = style.gradientOrientation.0
            gradientLayer.endPoint = style.gradientOrientation.1
            gradientLayer.frame = frame
            
            gradientLayer.mask = maskLayer
            self.layer.addSublayer(gradientLayer)
            layer.fillColor = nil
            layer.gradientLayer = gradientLayer
        } else {
            layer.fillColor = style.fillColor?.CGColor
        }
        self.layer.addSublayer(layer)
        
        return layer
    }
    
    public func addTextLayer(text:String, frame:CGRect, fontSize:CGFloat) -> CATextLayer {
        let layer = CATextLayer()
        
        layer.frame = frame
        layer.string = text
        layer.fontSize = fontSize
        layer.foregroundColor = style.strokeColor.CGColor
        layer.alignmentMode = kCAAlignmentCenter
        layer.wrapped = true
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
    
    public var gradientLayer:CALayer? {
        get {
            if let dict = self.style {
                return dict["gradientLayer"] as? CALayer
            }
            return nil
        }
        set {
            weak var layer = newValue
            if layer != nil || self.style != nil {
                if self.style == nil {
                    self.style = ["gradientLayer" : layer!]
                } else {
                    var newstyle = self.style
                    if layer != nil {
                        newstyle["gradientLayer"] = layer!
                        self.style = newstyle
                    } else {
                        if let layer = newstyle.removeValueForKey("gradientLayer") as? CALayer {
                            self.style = newstyle
                            layer.removeFromSuperlayer()
                        }
                    }
                }
            }
        }
    }
    
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
