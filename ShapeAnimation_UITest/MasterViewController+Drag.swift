//
//  MasterViewController+Drag.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/5.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics
import ShapeAnimation

extension MasterViewController {
    
    func testDragLayer(viewController:DetailViewController) -> AnimationBlock {
        return { (view) -> Void in
            if let layer = view.addImageLayer(named:"airship.png", center:CGPoint(x:100, y:200)) {
                layer.identifier = "airship1"
            }
            if let layer = view.addImageLayer(named:"airship.png", center:CGPoint(x:200, y:200)) {
                layer.identifier = "airship2"
            }
            
            viewController.data = DragGestureHandler(view)
        }
    }
    
}

class DragGestureHandler : NSObject {
    private let kVelocityDampening:CGFloat = 10
    var currentLayer:CALayer?
    
    init(_ view:UIView) {
        super.init()
        let panGesture = UIPanGestureRecognizer(target:self, action:Selector("handlePanGesture:"))
        let tapGesture = UITapGestureRecognizer(target:self, action:Selector("handleTapGesture:"))
        tapGesture.requireGestureRecognizerToFail(panGesture)
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(tapGesture)
    }
    
    func hitTest(view:UIView, point:CGPoint) -> CALayer? {
        currentLayer = nil
        if let sublayers = view.layer.sublayers {
            for layer in sublayers {
                let layer = layer as CALayer
                if layer.hitTest(point) != nil {
                    currentLayer = layer
                }
            }
        }
        return currentLayer
    }
    
    func handlePanGesture(sender:UIPanGestureRecognizer) {
        let view = sender.view!
        
        switch sender.state {
        case .Began:
            hitTest(view, point:sender.locationInView(view))
        case .Changed:
            if let layer = currentLayer {
                withDisableActions {
                    layer.position += sender.translationInView(view)
                }
                sender.setTranslation(CGPoint.zeroPoint, inView:view)
            }
        case .Ended:
            if let layer = currentLayer {
                var velocity = sender.velocityInView(view)
                velocity /= kVelocityDampening
                if velocity.magnitude > 1 {
                    let endPoint = layer.position + velocity
                    layer.constrainCenterToSuperview(endPoint)
                } else {
                    layer.bringOnScreen()
                }
            }
        default: ()
        }
    }
    
    func handleTapGesture(sender:UIPanGestureRecognizer) {
        let view = sender.view!
        if sender.state == .Ended {
            if let layer = hitTest(view, point:sender.locationInView(view)) {
                layer.tapAnimation().apply()
            }
        }
    }
}
