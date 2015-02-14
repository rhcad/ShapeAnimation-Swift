//
//  MasterViewController+Drag.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/5.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics
import ShapeAnimation

// MARK: Layer dragging and tapping demo

private var triangleState = 0

extension MasterViewController {
    
    func testDragLayer(viewController:DetailViewController) -> AnimationBlock {
        return { view in
            let imageName = "airship.png"
            if let layer = view.addImageLayer(named:imageName, center:CGPoint(x:100, y:200)) {
                layer.identifier = "airship1"
                layer.didTap = { layer.tapAnimation().apply() }
            }
            if let layer = view.addImageLayer(named:imageName, center:CGPoint(x:200, y:200)) {
                layer.identifier = "airship2"
                layer.setAffineTransform(CGAffineTransform(scale:1.5))
                layer.didTap = { layer.flipHorizontally().apply() }
            }
            if let layer = view.addImageLayer(named:imageName, center:CGPoint(x:300, y:200)) {
                layer.identifier = "airship3"
                layer.didTap = { layer.rotationAnimation(CGFloat(M_PI_2)).apply(duration:0.3) }
            }
            
            // Add a triangle with gradient fill
            let triangle = view.addSVGPathLayer("M10,20L150,40 120,120Z")
            triangle.apply(Gradient(colors:[(0.5, 0.5, 0.9, 1.0), (0.9, 0.9, 0.3, 1.0)]))
            triangle.didTap = {
                switch ++triangleState % 4 {
                    case 0: triangle.flipHorizontally().apply()
                    case 1: triangle.flipVertically().apply()
                    case 2: triangle.rotate360Degrees().apply()
                    case 3:
                        let path = CGPathFromSVGPath("M100,0 L41.22,180.9 195.1,69.09 4.89,69.09 158.77,180.9z")
                        triangle.switchPathAnimation(path).apply()
                    default: ()
                }
            }
            
            viewController.data = DragGestureHandler(view)
            self.testHamburger(view)
        }
    }
}

class DragGestureHandler : NSObject {
    private let kVelocityDampening:CGFloat = 10
    weak var currentLayer:CALayer?
    
    init(_ view:UIView) {
        super.init()
        let panGesture = UIPanGestureRecognizer(target:self, action:Selector("handlePanGesture:"))
        let tapGesture = UITapGestureRecognizer(target:self, action:Selector("handleTapGesture:"))
        tapGesture.requireGestureRecognizerToFail(panGesture)
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(tapGesture)
    }
    
    func handlePanGesture(sender:UIPanGestureRecognizer) {
        let view = sender.view as! ShapeView!
        
        switch sender.state {
        case .Began:
            currentLayer = view.hitTest(sender.locationInView(view))
        case .Changed:
            if let layer = currentLayer {
                withDisableActions {
                    layer.position += sender.translationInView(view)
                    if let gradientLayer = layer.gradientLayer {
                        gradientLayer.position += sender.translationInView(view)
                    }
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
        let view = sender.view as! ShapeView!
        if sender.state == .Ended {
            if let layer = view.hitTest(sender.locationInView(view)) {
                layer.didTap?()
            }
        }
    }
}
