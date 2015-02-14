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
                    style.lineCap = kCGLineCapRound
                case kCALineCapSquare:
                    style.lineCap = kCGLineCapSquare
                default:
                    style.lineCap = kCGLineCapButt
            }
            switch self.lineJoin {
                case kCALineJoinMiter:
                    style.lineJoin = kCGLineJoinMiter
                case kCALineJoinBevel:
                    style.lineJoin = kCGLineJoinBevel
                default:
                    style.lineJoin = kCGLineJoinRound
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
