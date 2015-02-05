//
//  CALayer+ID.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/4.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

private var LayerIDKey = 13

public extension CALayer {
    
    public var identifier: String? {
        get {
            let defv:String? = nil
            return getAssociatedObject(self, &LayerIDKey, defv)
        }
        set {
            setAssociatedObject(self, &LayerIDKey, newValue)
        }
    }
    
    public func layerWithIdentifier(identifier:String) -> CALayer? {
        if let sublayers = self.sublayers {
            for layer in sublayers {
                let layer = layer as CALayer
                if let lid = layer.identifier {
                    if lid == identifier {
                        return layer
                    }
                }
            }
        }
        return nil
    }
    
    public func layerWithIdentifier(identifier:String, layer:CALayer) -> CALayer? {
        return layer.layerWithIdentifier(identifier)
    }
}
