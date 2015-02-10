//
//  CAShapeLayer+Path.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 1/20/15.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

public extension CAShapeLayer {
    
    //! The path mapped to the parent layer's coordinate systems.
    public var pathToSuperlayer:CGPath! {
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
