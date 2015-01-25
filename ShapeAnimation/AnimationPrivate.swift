//
//  AnimationPrivate.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/20.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import UIKit
import QuartzCore
import SwiftGraphics

public class AnimationDelagate : NSObject {
    
    public var didStart:((CAAnimation!) -> Void)?
    public var didStop :(() -> Void)?
    
    override public func animationDidStart(anim:CAAnimation!) {
        didStart?(anim)
    }
    
    override public func animationDidStop(anim:CAAnimation!, finished flag:Bool) {
        self.didStop?()
    }
    
}

public extension CAAnimation {
    
    public var didStart:((CAAnimation!) -> Void)? {
        get {
            let delegate = self.delegate as? AnimationDelagate
            return delegate?.didStart
        }
        set {
            if let delegate = self.delegate as? AnimationDelagate {
                delegate.didStart = newValue
            }
            else if newValue != nil {
                var delegate = AnimationDelagate()
                delegate.didStart = newValue
                self.delegate = delegate
            }
        }
    }
    
    public var didStop:(() -> Void)? {
        get {
            let delegate = self.delegate as? AnimationDelagate
            return delegate?.didStop
        }
        set {
            if let delegate = self.delegate as? AnimationDelagate {
                delegate.didStop = newValue
            }
            else if newValue != nil {
                var delegate = AnimationDelagate()
                delegate.didStop = newValue
                self.delegate = delegate
            }
        }
    }
    
}

public extension CALayer {
    func addAnimation(anim: CAAnimation!) {
        return addAnimation(anim, forKey:nil)
    }
}

// MARK: Relations between CALayer and CAGradientLayer

public struct LayerLink {
    private static var link:[(CALayer, CALayer)] = []
    
    public static func add(p:(CALayer, CALayer)) {
        link.append(p)
    }
    public static func find(l:CALayer) -> CALayer? {
        for i in link {
            if i.0 == l {
                return i.1
            }
        }
        return nil
    }
    public static func remove(l:CALayer) {
        var i = 0
        for (f,s) in link {
            if f == l || s == l {
                link.removeAtIndex(i)
                remove(l)
                return
            }
            i++
        }
    }
}
