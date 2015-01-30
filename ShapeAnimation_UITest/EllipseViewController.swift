//
//  EllipseViewController.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/30.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import UIKit
import SwiftGraphics
import ShapeAnimation

class EllipseViewController: DetailViewController {
    @IBOutlet weak var rxSlider: UISlider!
    @IBOutlet weak var rySlider: UISlider!
    @IBOutlet weak var angleSlider: UISlider!
    var animationLayer:AnimationLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationLayer = animationView.addAnimationLayer(frame:animationView.bounds,
            properties:[("rx", 20), ("ry", 20), ("angle", 0)]) { (layer, ctx) -> Void in
                let rx = layer.getProperty("rx")
                let ry = layer.getProperty("ry")
                let angle = layer.getProperty("angle")
                
                let ellipse = Ellipse(center:self.animationView.bounds.mid,
                    semiMajorAxis:max(rx, ry), semiMinorAxis:min(rx, ry),
                    rotation:angle + (rx < ry ? CGFloat(M_PI_2) : 0))
                ctx.stroke(ellipse.asBezierChain)
                
                self.drawLabelText(ctx, rx, ry, angle)
        }
        
        radiusXChanged(rxSlider)
        radiusYChanged(rySlider)
        angleChanged(angleSlider)
    }
    
    @IBAction func radiusXChanged(sender: UISlider) {
        animationLayer.setProperty(sender.value, key:"rx")
    }
    
    @IBAction func radiusYChanged(sender: UISlider) {
        animationLayer.setProperty(sender.value, key:"ry")
    }
    
    @IBAction func angleChanged(sender: UISlider) {
        animationLayer.setProperty(DegreesToRadians(CGFloat(-sender.value)), key:"angle")
    }
    
    private func drawLabelText(ctx:CGContext, _ rx:CGFloat, _ ry:CGFloat, _ angle:CGFloat) {
        func round1(x:CGFloat) -> CGFloat { return round(x * 10) / 10 }
        let deg = round1(RadiansToDegrees(angle))
        let text:NSString = "rx=\(round1(rx))\nry=\(round1(ry))\nangle=\(deg)"
        let attr = [NSFontAttributeName: UIFont.systemFontOfSize(17)]
        UIGraphicsPushContext(ctx)
        text.drawAtPoint(CGPoint(x:10, y:10), withAttributes:attr)
        UIGraphicsPopContext()
    }
}
