//
//  CALayer+Drag.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/6.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics
import SwiftUtilities

private var LayerTapKey = 14
private var LayerSelectedKey = 15

public extension CALayer {
    func constrainCenterToSuperview(center:CGPoint) {
        let kEdgeBuffer:CGFloat = 4
        var constrain = superlayer!.bounds.insetted(dx:kEdgeBuffer, dy:kEdgeBuffer)
        constrain.inset(dx: frame.width / 2, dy: frame.height / 2)
        let pt = constrain.isEmpty ? superlayer!.bounds.mid : center.clampedTo(constrain)
        moveAnimation(to: pt, relative:false).apply()
    }
    
    func bringOnScreen() {
        if !superlayer!.bounds.contains(frame) {
            constrainCenterToSuperview(position)
        }
    }
    
    public var didTap: (() -> Void)? {
        get {
            let defv:(() -> Void)? = nil
            return getAssociatedWrappedObject(self, key: &LayerTapKey, defaultValue: defv)
        }
        set {
            setAssociatedWrappedObject(self, key: &LayerTapKey, value: newValue)
        }
    }
    
    public var selected: Bool {
        get {
            let defv:NSObject? = nil
            return getAssociatedWrappedObject(self, key: &LayerSelectedKey, defaultValue: defv) != nil
        }
        set {
            if (newValue != selected) {
                weak var value = self
                setAssociatedWrappedObject(self, key: &LayerSelectedKey, value: newValue ? value : nil)
            }
        }
    }
}
