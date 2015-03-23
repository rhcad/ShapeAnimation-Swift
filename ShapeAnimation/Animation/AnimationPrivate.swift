//
//  AnimationPrivate.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/20.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

private var stopping = 0

internal class AnimationDelagate : NSObject {
    
    internal var didStart:((CAAnimation!) -> Void)?
    internal var didStop :(() -> Void)?
    internal var willStop :(() -> Void)?
    internal var finished = true
    
    override internal func animationDidStart(anim:CAAnimation!) {
        didStart?(anim)
        didStart = nil
    }
    
    override internal func animationDidStop(anim:CAAnimation!, finished:Bool) {
        self.finished = finished
        if finished {
            willStop?()
            didStop?()
        } else {
            stopping++
            willStop?()
            didStop?()
            stopping--
        }
        willStop = nil
        didStop = nil
    }
    
    internal class func groupDidStop(completion:() -> Void, finished:Bool) {
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
    
    internal var finished:Bool {
        get {
            if let delegate = self.delegate as? AnimationDelagate {
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
    
    internal class var isStopping:Bool { return stopping > 0 }
}
