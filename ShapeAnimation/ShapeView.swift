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

public class ShapeView : UIView {
    
    public var strokeColor     = UIColor(white:0, alpha:0.8)
    public var fillColor       : UIColor?
    public var strokeWidth     : CGFloat = 3.0
    public var lineCap         = kCALineCapButt
    public var lineJoin        = kCALineJoinRound
    public var lineDash        : [CGFloat]?
    
    public func addShapeLayer(path:CGPath) -> CAShapeLayer {
        let frame = path.bounds
        var xf    = CGAffineTransform(translation:-frame.origin)
        let layer = CAShapeLayer()

        layer.frame = frame
        layer.path = CGPathCreateCopyByTransformingPath(path, &xf)
        layer.strokeColor = strokeColor.CGColor
        layer.fillColor = fillColor?.CGColor
        layer.lineWidth = strokeWidth
        layer.lineCap = path.isClosed ? kCALineCapRound : lineCap
        layer.lineJoin = lineJoin
        layer.lineDashPattern = lineDash
        
        self.layer.addSublayer(layer)
        
        return layer
    }

}

public extension CAShapeLayer {
    
    public var transformedPath:CGPath {
        get {
            var xf = CGAffineTransform(translation:frame.origin)
            return CGPathCreateCopyByTransformingPath(path, &xf)
        }
        set(v) {
            frame = v.bounds
            var xf = CGAffineTransform(translation:-frame.origin)
            path = CGPathCreateCopyByTransformingPath(v, &xf)
        }
    }
    
}
