//
//  AnimationPrivate.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/20.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

private var stopping = 0

public class AnimationDelagate : NSObject {
    
    public var didStart:((CAAnimation!) -> Void)?
    public var didStop :(() -> Void)?
    public var willStop :(() -> Void)?
    public var finished = true
    
    override public func animationDidStart(anim:CAAnimation!) {
        didStart?(anim)
    }
    
    override public func animationDidStop(anim:CAAnimation!, finished:Bool) {
        /*
        let keypath = (anim as? CAPropertyAnimation)?.keyPath
        let name = keypath != nil ? keypath! : anim.description
        
        if let layerid = anim.valueForKey("layerID") as? String {
            println("animationDidStop \(layerid) \(name)")
        } else {
            println("animationDidStop \(name)")
        }*/
        
        self.finished = finished
        if finished {
            self.willStop?()
            self.didStop?()
        } else {
            stopping++
            self.willStop?()
            self.didStop?()
            stopping--
        }
    }
    
    public class func groupDidStop(completion:() -> Void, finished:Bool) {
        if finished {
            completion()
        } else {
            stopping++
            completion()
            stopping--
        }
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
    
    public var willStop:(() -> Void)? {
        get {
            let delegate = self.delegate as? AnimationDelagate
            return delegate?.willStop
        }
        set {
            if let delegate = self.delegate as? AnimationDelagate {
                delegate.willStop = newValue
            }
            else if newValue != nil {
                var delegate = AnimationDelagate()
                delegate.willStop = newValue
                self.delegate = delegate
            }
        }
    }
    
    public var finished:Bool {
        get {
            if let delegate = self.delegate as? AnimationDelagate {
                if let p = self as? CAPropertyAnimation {
                    if !(delegate.finished) {
                        println(p.keyPath)
                    }
                }
                return delegate.finished
            }
            return true
        }
        set {
            if let delegate = self.delegate as? AnimationDelagate {
                delegate.finished = newValue
            }
            else {
                var delegate = AnimationDelagate()
                delegate.finished = finished
                self.delegate = delegate
            }
        }
    }
    
    public class var isStopping:Bool { return stopping > 0 }
}

public func withDisableActions(layer:CALayer, animation:CAAnimation, block:() -> Void) {
    let forwards = animation.fillMode == kCAFillModeForwards || animation.fillMode == kCAFillModeBoth
    if !animation.autoreverses && forwards {
        let old = CATransaction.disableActions()
        CATransaction.setDisableActions(true)
        block()
        CATransaction.setDisableActions(old)
    }
}
