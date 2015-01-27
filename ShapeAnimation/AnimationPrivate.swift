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
