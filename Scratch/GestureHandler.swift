//
//  GestureHandler.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 2/8/15.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

public protocol PanHandler {
    func touchBegan(point:CGPoint)
    func touchMoved(point:CGPoint)
    func touchEnded(point:CGPoint)
}

public class GestureHandler : NSObject {
    public let panRecognizer:UIPanGestureRecognizer!
    public var panHandler:PanHandler?
    
    public init(view:UIView) {
        super.init()
        
        panRecognizer = UIPanGestureRecognizer(target:self, action:"panHandler:")
        panRecognizer.maximumNumberOfTouches = 1
        
        view.addGestureRecognizer(panRecognizer)
    }
    
    func panHandler(sender:UIGestureRecognizer) {
        func locationInView() -> CGPoint { return sender.locationInView(sender.view!) }
        switch sender.state {
            case .Began:
                panHandler?.touchBegan(locationInView())
            case .Changed: ()
                panHandler?.touchMoved(locationInView())
            case .Ended: ()
                panHandler?.touchEnded(locationInView())
            default: ()
        }
    }
}
