//
//  CAShapeLayer+Style.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/29.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

public typealias PaintStyle = SwiftGraphics.Style

public extension CAShapeLayer {
    public var paintStyle: PaintStyle! {
        get {
            var style = PaintStyle()
            style.fillColor = self.fillColor
            style.strokeColor = self.strokeColor
            style.lineWidth = self.lineWidth
            style.miterLimit = self.miterLimit
            if let lineDashPattern = self.lineDashPattern {
                style.lineDash = lineDashPattern.map{ CGFloat($0 as NSNumber) }
            }
            style.lineDashPhase = self.lineDashPhase
            style.alpha = CGFloat(self.opacity)
            style.miterLimit = self.miterLimit
            // TODO flatness, blendMode
            
            switch self.lineCap {
                case kCALineCapRound:
                    style.lineCap = CGLineCap.Round
                case kCALineCapSquare:
                    style.lineCap = CGLineCap.Square
                default:
                    style.lineCap = CGLineCap.Butt
            }
            switch self.lineJoin {
                case kCALineJoinMiter:
                    style.lineJoin = CGLineJoin.Miter
                case kCALineJoinBevel:
                    style.lineJoin = CGLineJoin.Bevel
                default:
                    style.lineJoin = CGLineJoin.Round
            }
            return style
        }
        set {
            apply(newValue)
        }
    }
    
    public func apply(newStyle:PaintStyle) {
        self.fillColor = newStyle.fillColor
        if let strokeColor = newStyle.strokeColor {
            self.strokeColor = strokeColor
        }
        if let lineWidth = newStyle.lineWidth {
            self.lineWidth = lineWidth
        }
        if let lineCap = newStyle.lineCap {
            switch lineCap {
            case CGLineCap.Round:
                self.lineCap = kCALineCapRound
            case CGLineCap.Square:
                self.lineCap = kCALineCapSquare
            default:
                self.lineCap = kCALineCapButt
            }
        }
        if let lineJoin = newStyle.lineJoin {
            switch lineJoin {
            case CGLineJoin.Miter:
                self.lineJoin = kCALineJoinMiter
            case CGLineJoin.Bevel:
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
        if let _ = newStyle.flatness {
            // TODO flatness
        }
        if let alpha = newStyle.alpha {
            self.opacity = Float(alpha)
        }
        if let _ = newStyle.blendMode {
            // TODO blendMode
        }
    }
}
