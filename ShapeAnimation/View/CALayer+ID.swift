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
            return getAssociatedObject(self, &LayerIDKey) as? String
        }
        set {
            if newValue != identifier {
                setAssociatedObject(self, &LayerIDKey, newValue!)
            }
        }
    }
    
    public func layerWithIdentifier(identifier:String) -> CALayer? {
        var ret:CALayer?
        enumerateLayers { layer in
            if let lid = layer.identifier {
                if lid == identifier {
                    ret = layer
                }
            }
        }
        return ret
    }
    
    public func layerWithIdentifier(identifier:String, layer:CALayer) -> CALayer? {
        return layer.layerWithIdentifier(identifier)
    }
}

public extension ShapeView {
    public func layerWithIdentifier(identifier:String) -> CALayer? {
        return sublayer.layerWithIdentifier(identifier)
    }
}
