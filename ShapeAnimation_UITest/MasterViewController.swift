//
//  MasterViewController.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/15.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import UIKit
import SwiftGraphics
import ShapeAnimation

class MasterViewController: UITableViewController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController = segue.destinationViewController as DetailViewController
        
        switch segue.identifier! as NSString {
        case "Add Lines":
            viewController.title = NSLocalizedString("Add Lines", comment:"")
            testAddLines(viewController)
            
        case "Move Lines":
            viewController.title = NSLocalizedString("Move Lines", comment:"")
            testMoveLines(viewController)
            
        case "Rotate Polygons":
            viewController.title = NSLocalizedString("Rotate Polygons with Text", comment:"")
            testRotatePolygons(viewController)
            
        case "Radar Circles":
            viewController.title = NSLocalizedString("Radar Circles", comment:"")
            testRadarCircles(viewController)
            
        default:
            println("Hello TouchVG")
        }
    }
    
    private func testAddLines(viewController:DetailViewController) {
        viewController.animationBlock = { (view) -> Void in
            view.style.strokeWidth = 8
            
            let points1 = [(10.0,20.0),(150.0,40.0),(120.0,320.0)].map{ CGPoint($0) }
            let layer1 = view.addLinesLayer(points1, closed:true)
            layer1.strokeEndAnimation().apply() {
                layer1.shakeAnimation().apply()
            }
            
            view.style.strokeColor = UIColor.blueColor()
            
            let xf2 = CGAffineTransform(tx:100.0, ty:0.0)
            let la2 = view.addLinesLayer(points1.map { $0 * xf2 }, closed:true)
            la2.scaleAnimation(from:1, to:1.1, repeatCount:3).apply(duration:0.3)
            
            view.style.strokeColor = UIColor.greenColor()
            
            let xf3 = CGAffineTransform(tx:200.0, ty:0.0)
            let la3 = view.addLinesLayer(points1.map { $0 * xf3 }, closed:true)
            la3.flashAnimation(repeatCount:6).apply()
        }
    }
    
    private func testMoveLines(viewController:DetailViewController) {
        viewController.animationBlock = { (view) -> Void in
            var path = CGPathCreateMutable()
            path.move(CGPoint(x:80, y:70))
            path.addCubicCurveToPoint(CGPoint(x:250, y:220), control1:CGPoint(x:10, y:300), control2:CGPoint(x:150, y:375))
            path.addSmoothQuadCurveToPoint(CGPoint(x:120, y:120))
            
            view.style.gradientColors = [UIColor(red:0.5, green:0.5, blue:0.9, alpha:1.0),
                UIColor(red:0.9, green:0.9, blue:0.3, alpha:1.0)]
            let points = [(10.0, 20.0), (150.0, 40.0), (120.0, 120.0)].map{ CGPoint($0) }
            let layer1 = view.addLinesLayer(points, closed:true)
            
            let a1 = layer1.moveOnPathAnimation(path).set {$0.duration=1.6}
            let a2 = layer1.rotate360Degrees().set {$0.repeatCount=2}
            let a3 = layer1.lineWidthAnimation(from:0, to:5)
            animationGroup([a1, a2, a3]).set {$0.autoreverses=true;$0.repeatCount=HUGE}.apply()
            
            let pathLayer = view.addLinesLayer([], closed:false)
            pathLayer.transformedPath = path
            let a4 = pathLayer.strokeColorAnimation(from:UIColor.lightGrayColor(), to:UIColor.greenColor())
                .set{$0.autoreverses=true;$0.repeatCount=HUGE}
            let a5 = pathLayer.dashPhaseAnimation(from:0, to:20)
            pathLayer.lineDashPattern = [5, 5]
            animationGroup([a4, a5]).set{$0.repeatCount=HUGE}.apply()
        }
    }
    
    private func testRotatePolygons(viewController:DetailViewController) {
        viewController.animationBlock = { (view) -> Void in
            view.style.gradientColors = [UIColor(red:0, green:0.5, blue:1, alpha:1),
                UIColor(red:0, green:1, blue:1, alpha:1)]
            
            var animations:[AnimationPair] = []
            
            for (i, character) in enumerate("swift") {
                let layer = view.addPolygonLayer(5, center:CGPoint(x:50 + 60*i, y:50), radius:25)
                let textLayer = view.addTextLayer(String(character), frame:layer.frame, fontSize:35)
                
                animations.append(layer.rotationAnimation(angle: CGFloat(2 * M_PI))
                    .setBeginTime(i, gap:0.3, duration:1.5))
                animations.append(textLayer.rotationAnimation(angle: CGFloat(2 * M_PI))
                    .setBeginTime(i, gap:0.3, duration:1.5))
            }
            applyAnimations(animations, nil)
        }
    }
    
    private func testRadarCircles(viewController:DetailViewController) {
        viewController.animationBlock = { (view) -> Void in
            let count = 6
            let duration: Double = 2
            
            view.style.strokeWidth = 1
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
    
}
