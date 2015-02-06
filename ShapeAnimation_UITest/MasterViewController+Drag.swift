//
//  MasterViewController+Drag.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/5.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

extension MasterViewController {
    
    func testDragLayer(viewController:DetailViewController) -> AnimationBlock {
        return { (view) -> Void in
            if let layer = view.addSVGLayer(named:"lion.svg", maxSize:CGSize(w:100, h:100)) {
                layer.identifier = "lion"
            }
            if let layer = view.addImageLayer(named:"airship.png", center:CGPoint(x:100, y:200)) {
                layer.identifier = "airship1"
            }
            if let layer = view.addImageLayer(named:"airship.png", center:CGPoint(x:200, y:200)) {
                layer.identifier = "airship2"
            }
            
            let handler = DragGestureHandler()
            viewController.data = handler
            view.addGestureRecognizer(handler.createPanGesture())
        }
    }
    
}

class DragGestureHandler : NSObject, UIGestureRecognizerDelegate {
    private let kVelocityDampening:CGFloat = 10
    var currentLayer:CALayer?
    
    func createPanGesture() -> UIPanGestureRecognizer {
        let panGesture = UIPanGestureRecognizer(target:self, action:Selector("handlePanGesture:"))
        panGesture.delegate = self
        panGesture.delaysTouchesBegan = true
        return panGesture
    }
    
    func handlePanGesture(sender:UIPanGestureRecognizer) {
        let view = sender.view!
        
        switch sender.state {
        case .Began:
            if let sublayers = view.layer.sublayers {
                let pt = sender.locationInView(view)
                currentLayer = nil
                for layer in sublayers {
                    let layer = layer as CALayer
                    if layer.hitTest(pt) != nil {
                        currentLayer = layer
                    }
                }
            }
        case .Changed:
            if let layer = currentLayer {
                layer.position += sender.translationInView(view)
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
}
