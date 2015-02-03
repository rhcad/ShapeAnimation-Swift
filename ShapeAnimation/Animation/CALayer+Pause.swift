//
//  CALayer+Pause.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/20.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

public extension CALayer {
    
    public var paused:Bool {
        get {
            return self.speed == 0.0
        }
        set {
            if newValue && !paused {
                let pausedTime = convertTime(CACurrentMediaTime(), fromLayer:nil)
                self.speed = 0.0
                self.timeOffset = pausedTime
            }
            else if !newValue && paused {
                let pausedTime = self.timeOffset
                self.speed = 1.0
                self.timeOffset = 0.0
                self.beginTime = 0.0
                self.beginTime = convertTime(CACurrentMediaTime(), fromLayer:nil) - pausedTime
            }
        }
    }
    
}

public extension ShapeView {
    
    public var paused:Bool {
        get {
            var ret = false
            for l in self.layer.sublayers {
                let layer = l as CALayer
                ret = ret || layer.paused
            }
            return ret
        }
        set {
            for l in self.layer.sublayers {
                let layer = l as CALayer
                layer.paused = newValue
            }
        }
    }
    
    public func removeAllAnimations() {
        for layer in self.layer.sublayers {
            layer.removeAllAnimations()
        }
    }
    
}
