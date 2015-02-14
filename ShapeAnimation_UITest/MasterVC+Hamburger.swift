//
//  MasterViewController+Hamburger.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/5.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics
import ShapeAnimation

// MARK: Hamburger button demo

extension MasterViewController {
    func testHamburger(view:ShapeView) { // Modified from https://github.com/robb/hamburger-button
        let shortStroke = CGPathFromSVGPath("M2,2 h26")
        let outline = CGPathFromSVGPath("M10,27C12,27,28,27,40,27 56,27,51,2,27,2 13,2,2,13,2,27 "
            + "2,41,13,52,27,52 41,52,52,41,52,27 52,13,42,2,27,2 13,2,2,13,2,27") // 50x50
        let startpath = CGPathFromSVGPath("M10,27C12,27,28,27,40,27 56,27,51,2,27,2")
        let endpath = CGPathFromSVGPath("M27,2C13,2,2,13,2,27")
        
        let button = UIButton(frame:CGRect(x:300, y:10, w:54, h:54))
        let top    = view.addShapeLayer(shortStroke, position:CGPoint(x:14, y:27 - 9), superlayer:button.layer)
        let bottom = view.addShapeLayer(shortStroke, position:CGPoint(x:14, y:27 + 9), superlayer:button.layer)
        let middle = view.addShapeLayer(outline,     center:  CGPoint(x:27, y:27), superlayer:button.layer)
        
        for layer in [top, middle, bottom] {
            layer.strokeColor = CGColor.brownColor()
            layer.lineWidth = 4
            layer.lineCap = kCALineCapRound
            layer.masksToBounds = true
            
            let strokingPath = CGPathCreateCopyByStrokingPath(layer.path, nil, 4, kCGLineCapRound, kCGLineJoinMiter, 4)
            layer.bounds = CGPathGetPathBoundingBox(strokingPath)
        }
        
        let length          = outline.length
        let menuStart       = startpath.length / length
        let menuEnd         = 1 - endpath.length / length
        let hamburgerStart  = 8 / length
        let hamburgerEnd    = 30 / length
        
        middle.strokeStart = hamburgerStart
        middle.strokeEnd = hamburgerEnd
        top.setAnchorPoint(CGPoint(x:28.0 / 30.0, y:0.5))
        bottom.setAnchorPoint(CGPoint(x:28.0 / 30.0, y:0.5))
        
        var showsMenu: Bool = false {
            didSet {
                if showsMenu {
                    middle.strokeStartAnimation(to:menuStart)
                        .set(CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1))
                        .apply(duration:0.5)
                    middle.strokeEndAnimation(to:menuEnd)
                        .set(CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1))
                        .apply(duration:0.6)
                } else {
                    middle.strokeStartAnimation(to:hamburgerStart)
                        .set(CAMediaTimingFunction(controlPoints: 0.25, 0, 0.5, 1.2))
                        .setBeginTime(0.1).apply(duration:0.5)
                    middle.strokeEndAnimation(to:hamburgerEnd)
                        .set(CAMediaTimingFunction(controlPoints: 0.25, 0.3, 0.5, 0.9))
                        .apply(duration:0.6)
                }
                
                let translation = CATransform3DMakeTranslation(-4, 0, 0)
                let xftop = CATransform3DRotate(translation, -CGFloat(M_PI_4), 0, 0, 1)
                let xfbot = CATransform3DRotate(translation,  CGFloat(M_PI_4), 0, 0, 1)
                let timeFunc = CAMediaTimingFunction(controlPoints: 0.5, -0.8, 0.5, 1.85)
                top.transformAnimation(to:showsMenu ? xftop : CATransform3DIdentity)
                    .set(timeFunc).setBeginTime(showsMenu ? 0.25 : 0.05).apply(duration:0.4)
                bottom.transformAnimation(to:showsMenu ? xfbot : CATransform3DIdentity)
                    .set(timeFunc).setBeginTime(showsMenu ? 0.25 : 0.05).apply(duration:0.4)
            }
        }
        button.layer.didTap = { showsMenu = !showsMenu }
        button.addTarget(self, action: "toggle:", forControlEvents:.TouchUpInside)
        view.addSubview(button)
    }
    
    func toggle(sender: UIView!) {
        sender.layer.didTap?()
    }
}
