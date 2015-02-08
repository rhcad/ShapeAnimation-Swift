//
//  GestureHandlers.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 2/8/15.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

public class TwoFingersGestureHandler : UIGestureRecognizerDelegate {
    public let pinchRecognizer:UIPinchGestureRecognizer
    public let rotationRecognizer:UIRotationGestureRecognizer
    public let panRecognizer:UIPanGestureRecognizer
    
    public var recognizers:[UIGestureRecognizer] = {
        return [pinchRecognizer, rotationRecognizer, panRecognizer]
    }
    
    public init(view:UIView) {
        pinchRecognizer = UIPinchGestureRecognizer(target:self, action:"moveHandler:")
        rotationRecognizer = UIRotationGestureRecognizer(target:self, action:"moveHandler:")
        panRecognizer = UIPanGestureRecognizer(target:self, action:"moveHandler:")
        panRecognizer.minimumNumberOfTouches = 2
        panRecognizer.maximumNumberOfTouches = 2
        
        for recognizer in recognizers {
            recognizer.delegate = self
            view.addGestureRecognizer(recognizer)
        }
    }
    
    func moveHandler(sender:UIPanGestureRecognizer) {
        let view = sender.view!
        
        switch sender.state {
        case .Possible:
        case .Began:
        case .Changed:
        case .Ended:
        default: ()
        }
    }
}
