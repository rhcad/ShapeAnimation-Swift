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
        view.addSubview(HamburgerButton(frame:CGRect(x:300, y:10, w:54, h:54)))
    }
}

class HamburgerButton : UIButton {
    let shortStroke = CGPathFromSVGPath("M2,2 h26")
    let outline = CGPathFromSVGPath("M10,27C12,27,28,27,40,27 56,27,51,2,27,2 13,2,2,13,2,27 "
        + "2,41,13,52,27,52 41,52,52,41,52,27 52,13,42,2,27,2 13,2,2,13,2,27") // 50x50
    let startpath = CGPathFromSVGPath("M10,27C12,27,28,27,40,27 56,27,51,2,27,2")
    let endpath = CGPathFromSVGPath("M27,2C13,2,2,13,2,27")
    
    var top:CAShapeLayer!
    var middle:CAShapeLayer!
    var bottom:CAShapeLayer!
    
    var length:CGFloat!
    var menuStart:CGFloat!
    var menuEnd:CGFloat!
    var hamburgerStart:CGFloat!
    var hamburgerEnd:CGFloat!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    private func initView() {
        length          = outline.length
        menuStart       = startpath.length / length
        menuEnd         = 1 - endpath.length / length
        hamburgerStart  = 8 / length
        hamburgerEnd    = 30 / length
        
        let view = ShapeView()
        top    = view.addShapeLayer(shortStroke, position:CGPoint(x:14, y:27 - 9), superlayer:self.layer)
        bottom = view.addShapeLayer(shortStroke, position:CGPoint(x:14, y:27 + 9), superlayer:self.layer)
        middle = view.addShapeLayer(outline,     center:  CGPoint(x:27, y:27), superlayer:self.layer)
        
        for layer in [top, middle, bottom] {
            layer.strokeColor = CGColor.brownColor()
            layer.lineWidth = 4
            layer.lineCap = kCALineCapRound
            layer.masksToBounds = true
            
            let strokingPath = CGPathCreateCopyByStrokingPath(layer.path, nil, 4, kCGLineCapRound, kCGLineJoinMiter, 4)
            layer.bounds = CGPathGetPathBoundingBox(strokingPath)
            self.layer.addSublayer(layer)
        }
        
        middle.strokeStart = hamburgerStart
        middle.strokeEnd = hamburgerEnd
        top.setAnchorPoint(CGPoint(x:28.0 / 30.0, y:0.5))
        bottom.setAnchorPoint(CGPoint(x:28.0 / 30.0, y:0.5))
        
        addTarget(self, action: "toggle:", forControlEvents:.TouchUpInside)
    }
    
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
    
    func toggle(sender: UIView!) {
        showsMenu = !showsMenu
    }
}
