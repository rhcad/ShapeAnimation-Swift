//
//  EllipseViewController.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/30.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics
import ShapeAnimation

class EllipseViewController: DetailViewController {
    @IBOutlet weak var rxSlider: UISlider!
    @IBOutlet weak var rySlider: UISlider!
    @IBOutlet weak var angleSlider: UISlider!
    
    var animationLayer:AnimationLayer!
    var ballLayer:CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationLayer = animationView.addAnimationLayer(frame:animationView.bounds,
            properties:[("rx", 20), ("ry", 20), ("angle", 0)]) { (layer, ctx) -> Void in
                let ellipse = self.makeEllipse(layer)
                ctx.stroke(ellipse.asBezierChain)
                self.drawLabelText(ctx, ellipse.a, ellipse.b, ellipse.rotation)
        }
        animationLayer.didStart = { self.ballLayer?.removeLayer(); return }
        animationLayer.didStop = { self.addBallLayer() }
        
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
    
    private func makeEllipse(layer:AnimationLayer) -> Ellipse {
        let rx = layer.getProperty("rx")
        let ry = layer.getProperty("ry")
        let angle = layer.getProperty("angle")
        
        return Ellipse(center:self.animationView.bounds.mid,
            semiMajorAxis:max(rx, ry),
            semiMinorAxis:min(rx, ry),
            rotation:angle + (rx < ry ? CGFloat(M_PI_2) : 0))
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
    
    private func addBallLayer() {
        var gradient = Gradient(colors:[(1.0,0.0,0.0), (0.1,0.0,0.0)], axial:true)
        gradient.orientation = (CGPoint(x:0.3, y:-0.3), CGPoint(x:0, y:1.4))
        
        ballLayer = animationView.addCircleLayer(center:CGPoint.zeroPoint, radius:5)
        ballLayer?.apply(gradient)
        
        let ellipse = self.makeEllipse(animationLayer)
        ballLayer!.moveOnPathAnimation(ellipse.cgpath).forever().set{ anim in
            anim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear) }.apply()
    }
}
