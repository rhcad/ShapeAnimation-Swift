//
//  CALayer+Drag.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/6.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

public extension CALayer {
    func constrainCenterToSuperview(center:CGPoint) {
        let kEdgeBuffer:CGFloat = 4
        var constrain = superlayer.bounds.insetted(dx:kEdgeBuffer, dy:kEdgeBuffer)
        constrain.inset(dx: frame.width / 2, dy: frame.height / 2)
        let pt = constrain.isEmpty ? superlayer.bounds.mid : center.clampedTo(constrain)
        moveAnimation(to: pt, relative:false).apply()
    }
    
    func bringOnScreen() {
        if !superlayer.bounds.contains(frame) {
            constrainCenterToSuperview(position)
        }
    }
}
