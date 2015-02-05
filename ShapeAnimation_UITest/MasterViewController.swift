//
//  MasterViewController.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/15.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics
import ShapeAnimation

class MasterViewController: UITableViewController {
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController = segue.destinationViewController as DetailViewController
        
        switch segue.identifier! as NSString {
        case "Add Lines":
            viewController.animationBlock = testAddLines(viewController)
        case "Move Lines":
            viewController.animationBlock = testMoveLines(viewController)
        case "Rotate Polygons":
            viewController.animationBlock = testRotatePolygons(viewController)
        case "Radar Circles":
            viewController.animationBlock = testRadarCircles(viewController)
        case "Jumping Ball":
            viewController.animationBlock = testJumpingBall(viewController)
        default:
            println("Hello Swift")
        }
        viewController.title = NSLocalizedString(segue.identifier! as NSString, comment:"")
    }
    
    // Demo about strokeEndAnimation, lineWidthAnimation, scaleAnimation, shakeAnimation and flashAnimation.
    private func testAddLines(viewController:DetailViewController) -> AnimationBlock {
        return { (view) -> Void in
            view.style.lineWidth = 7
            
            let points1 = [(10.0,20.0),(150.0,40.0),(120.0,320.0)].map{ CGPoint($0) }
            let la1 = view.addLinesLayer(points1, closed:true, color:CGColor.redColor())
            animationGroup([la1.strokeEndAnimation(), la1.lineWidthAnimation(from:0, to:5)]).apply() {
                la1.shakeAnimation().apply()
            }
            
            let xf2 = CGAffineTransform(tx:100.0, ty:0.0)
            let la2 = view.addLinesLayer(points1.map { $0 * xf2 }, closed:true, color:CGColor.purpleColor())
            let la3 = view.addLinesLayer(points1.map { $0 * xf2 * xf2 }, closed:true, color:CGColor.greenColor())
            
            la2.scaleAnimation(from:1, to:1.1, repeatCount:3).apply(duration:0.3) {
                la3.flashAnimation().apply()
            }
        }
    }
    
    // Demo about moveOnPathAnimation, moveAnimation, rotationAnimation, dashPhaseAnimation and animationGroup.
    // Rotate and move a picture and polygon with gradient fill along the path.
    private func testMoveLines(viewController:DetailViewController) -> AnimationBlock {
        return { (view) -> Void in
            // Create a smooth path
            var path = CGPathCreateMutable()
            path.move(CGPoint(x:120, y:70))
            path.addCubicCurveToPoint(CGPoint(x:250, y:220),
                control1:CGPoint(x:0, y:200), control2:CGPoint(x:150, y:375))
            path.addSmoothQuadCurveToPoint(CGPoint(x:120, y:120))
            
            // Add a triangle with gradient fill
            view.gradient.setColors([(0.5, 0.5, 0.9, 1.0), (0.9, 0.9, 0.3, 1.0)])
            let points = [(10.0, 20.0), (150.0, 40.0), (120.0, 120.0)].map{ CGPoint($0) }
            let layer1 = view.addLinesLayer(points, closed:true)
            
            // Move and rotate the triangle along the path
            let a1 = layer1.moveOnPathAnimation(path).set {$0.duration=1.6}
            let a2 = layer1.rotate360Degrees().set {$0.repeatCount=2}
            animationGroup([a1, a2]).set {$0.autoreverses=true;$0.repeatCount=HUGE}.apply()
            
            // Show the path with vary dash phase and color
            let pathLayer = view.addLinesLayer([CGPoint.zeroPoint])
            pathLayer.transformedPath = path
            pathLayer.lineDashPattern = [5, 5]
            let a4 = pathLayer.strokeColorAnimation(from:CGColor.lightGrayColor(), to:CGColor.greenColor())
                .set{$0.autoreverses=true;$0.repeatCount=HUGE}
            let a5 = pathLayer.dashPhaseAnimation(from:0, to:20)
            animationGroup([a4, a5]).set{$0.repeatCount=HUGE}.apply()
            
            // Rotate and move a picture along the path
            if let imageLayer = view.addImageLayer(named:"airship.png", center:path.getPoint(0)!) {
                let startTagent = path.getPoint(1)! - path.getPoint(0)!
                imageLayer.rotationAnimation(angle:startTagent.direction).setBeginTime(1, gap:1).apply() {
                    imageLayer.moveOnPathAnimation(path, autoRotate:true).apply(duration:2) {
                        imageLayer.moveAnimation(to:CGPoint(x:500)).apply()
                    }
                }
            }
        }
    }
    
    // Demo about polygon with text and gradient fill moving and rotating one by one.
    // Modified from http://zulko.github.io/blog/2014/09/20/vector-animations-with-python/
    private func testRotatePolygons(viewController:DetailViewController) -> AnimationBlock {
        return { (view) -> Void in
            view.gradient.setColors([(0, 0.5, 1, 1), (0, 1, 1, 1)])
            view.gradient.orientation = (CGPoint.zeroPoint, CGPoint(x:1, y:1))
            
            var animations:[AnimationPair] = []
            
            for (i, c) in enumerate("swift") {
                let polygon = RegularPolygon(nside:5, center:CGPoint(x:50 + 60*i, y:50), radius:25)
                let edgeLayer = view.addLinesLayer(polygon.points, closed:true)
                let textLayer = view.addTextLayer(String(c), frame:polygon.incircle.frame, fontSize:30)
                
                animations.append(edgeLayer.rotationAnimation(angle: CGFloat(2 * M_PI))
                    .setBeginTime(i, gap:0.3, duration:1.5))
                animations.append(textLayer.rotationAnimation(angle: CGFloat(2 * M_PI))
                    .setBeginTime(i, gap:0.3, duration:1.5))
            }
            applyAnimations(animations) {
                let movement = CGPoint(x:300)
                for (i, anim) in enumerate(animations) {
                    anim.layer.moveAnimation(to:movement).setBeginTime(5 - i/2, gap:0.3).apply()
                }
            }
        }
    }
    
    // Demo about growing circles.
    private func testRadarCircles(viewController:DetailViewController) -> AnimationBlock {
        return { (view) -> Void in
            let count = 6
            let duration: Double = 2
            
            view.style.lineWidth = 1
            for i in 0..<count {
                let la1 = view.addCircleLayer(center:CGPoint(x:200, y:100), radius:15)
                let anim = animationGroup([la1.scaleAnimation(from:0, to:5),
                                           la1.opacityAnimation(from:1, to:0)])
                    .setBeginTime(i, gap:duration / Double(count), duration:duration)
                    .set {$0.repeatCount=HUGE; $0.fillMode = kCAFillModeBackwards}
                anim.apply()
            }
        }
    }
    
    // Demo about jumping ball with shadow.
    // Modified from http://zulko.github.io/blog/2014/09/20/vector-animations-with-python/
    private func testJumpingBall(viewController:DetailViewController) -> AnimationBlock {
        var gradient = Gradient(colors:[(1.0,0.0,0.0), (0.1,0.0,0.0)], axial:true)
        gradient.orientation = (CGPoint(x:0.3, y:-0.3), CGPoint(x:0, y:1.4))
        
        return { (view) -> Void in
            let layer = view.addAnimationLayer(frame:view.layer.bounds, properties:[("t", 0)]) {
                (layer, ctx) -> Void in
                let W = view.layer.bounds.width
                let H = view.layer.bounds.height
                let D:CGFloat = 3, r:CGFloat = 30       // radius of ball
                let DJ:CGFloat = W / 6, HJ = H / 2      // distance and height of jumping
                let ground:CGFloat = 0.75*H
                
                let t = layer.getProperty("t")
                
                let x = (-W / 3) + (5 * W / 3) * (t / D)
                let y = ground - HJ*4*(x % DJ)*(DJ-(x % DJ))/DJ**2
                let coef = (HJ-y)/HJ
                let sr = (1 - coef / 4) * r
                
                var sgradient = Gradient(colors: [CGColor.color(white:0, alpha:0.2-coef/5), CGColor.clearColor()], axial:true)
                sgradient.orientation = (CGPoint(y:0.5), CGPoint(x:1, y:0.5))
                
                let shadow = Ellipse(center:CGPoint(x:x, y:ground + r/2), size:CGSize(w:sr*2, h:sr))
                ctx.fillEllipseInRect(sgradient, rect: shadow.boundingBox)
                
                let ball = Circle(center:CGPoint(x:x, y:y), radius:r)
                ctx.fillEllipseInRect(gradient, rect: ball.frame)
            }
            layer.animationCreated = { $1.repeatCount=HUGE; $1.duration=5.0 }
            layer.setProperty(4, key: "t")
        }
    }
    
}

public extension ShapeView {
    
    public func addLinesLayer(points:[CGPoint], closed:Bool = false, color:CGColor) -> CAShapeLayer {
        style.strokeColor = color
        return addShapeLayer(Path(vertices:points, closed:closed).cgPath)
    }

}
