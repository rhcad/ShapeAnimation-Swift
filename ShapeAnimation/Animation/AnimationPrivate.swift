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
    public var finished = true
    
    override public func animationDidStart(anim:CAAnimation!) {
        didStart?(anim)
    }
    
    override public func animationDidStop(anim:CAAnimation!, finished:Bool) {
        self.finished = finished
        if finished {
            self.didStop?()
        } else {
            stopping++
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
