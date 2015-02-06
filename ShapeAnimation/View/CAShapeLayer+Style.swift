//
//  CAShapeLayer+Style.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/29.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

public typealias PaintStyle = SwiftGraphics.Style

private var LayerStyleKey = 10

public extension CAShapeLayer {
    var paintStyle: PaintStyle {
        get {
            let style = getAssociatedWrappedObject(self, &LayerStyleKey) as PaintStyle?
            if let style = style {
                return style
            }
            else {
                var style = Style.defaultStyle
                setAssociatedWrappedObject(self, &LayerStyleKey, style)
                return style
            }
        }
        set {
            setAssociatedWrappedObject(self, &LayerStyleKey, newValue)
            apply(newValue)
        }
    }
    
    func apply(newStyle:PaintStyle) {
        self.fillColor = newStyle.fillColor
        if let strokeColor = newStyle.strokeColor {
            self.strokeColor = strokeColor
        }
        if let lineWidth = newStyle.lineWidth {
            self.lineWidth = lineWidth
        }
        if let lineCap = newStyle.lineCap {
            switch lineCap.value {
            case kCGLineCapRound.value:
                self.lineCap = kCALineCapRound
            case kCGLineCapSquare.value:
                self.lineCap = kCALineCapSquare
            default:
                self.lineCap = kCALineCapButt
            }
        }
        if let lineJoin = newStyle.lineJoin {
            switch lineJoin.value {
            case kCGLineJoinMiter.value:
                self.lineJoin = kCALineJoinMiter
            case kCGLineJoinBevel.value:
                self.lineJoin = kCALineJoinBevel
            default:
                self.lineJoin = kCALineJoinRound
            }
        }
        if let miterLimit = newStyle.miterLimit {
            self.miterLimit = miterLimit
        }
        if let lineDash = newStyle.lineDash {
            self.lineDashPattern = lineDash
        }
        if let lineDashPhase = newStyle.lineDashPhase {
            self.lineDashPhase = lineDashPhase
        }
        if let flatness = newStyle.flatness {
            // TODO flatness
        }
        if let alpha = newStyle.alpha {
            self.opacity = Float(alpha)
        }
        if let blendMode = newStyle.blendMode {
            // TODO blendMode
        }
    }
}
