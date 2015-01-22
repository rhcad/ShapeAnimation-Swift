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
            
        default:
            println("Hello TouchVG")
        }
    }
    
    private func testAddLines(viewController:DetailViewController) {
        viewController.animationBlock = { (view) -> Void in
            view.strokeWidth = 8
            
            let layer1 = self.addLinesLayer(view, points:[(10.0,20.0),(150.0,40.0),(120.0,320.0)])
            layer1.strokeEndAnimation().apply() {
                layer1.shakeAnimation().apply()
            }
            
            let xf2 = CGAffineTransform(tx:100.0, ty:0.0)
            let points1 = layer1.transformedPath.points
            let points2 = points1.map { ($0 * xf2).asTuple }
            
            let la2 = self.addLinesLayer(view, points:points2, color: UIColor.blueColor())
            la2.scaleAnimation(from:1, to:1.1, repeatCount:3).apply(duration:0.3)
            
            let xf3 = CGAffineTransform(tx:200.0, ty:0.0)
            let points3 = points1.map { ($0 * xf3).asTuple }
            let la3 = self.addLinesLayer(view, points:points3, color: UIColor.greenColor())
            la3.flashAnimation(repeatCount:6).apply()
        }
    }
    
    private func testMoveLines(viewController:DetailViewController) {
        viewController.animationBlock = { (view) -> Void in
            var path = CGPathCreateMutable()
            path.move(CGPoint(x:80, y:70))
            path.addCubicCurveToPoint(CGPoint(x:250, y:220), control1:CGPoint(x:10, y:300), control2:CGPoint(x:150, y:375))
            path.addSmoothQuadCurveToPoint(CGPoint(x:120, y:120))
            
            let layer1 = self.addLinesLayer(view, points: [(10.0, 20.0), (150.0, 40.0), (120.0, 120.0)])
            let a1 = layer1.moveOnPathAnimation(path).set {$0.duration=1.6}
            let a2 = layer1.rotate360Degrees().set {$0.repeatCount=2}
            animationGroup([a1, a2]).set {$0.autoreverses=true}.apply()
            
            let pathLayer = self.addLinesLayer(view, points:[(10.0, 20.0)], color: UIColor.lightGrayColor())
            pathLayer.transformedPath = path
        }
    }
    
    private func testRotatePolygons(viewController:DetailViewController) {
        viewController.animationBlock = { (view) -> Void in
            
        }
    }
    
    private func addLinesLayer(view: ShapeView, points:[(CGFloat, CGFloat)]) -> CAShapeLayer {
        var path = CGPathCreateMutable()
        
        path.move(CGPoint(points[0]))
        for i in 1..<points.count {
            path.addLine(CGPoint(points[i]))
        }
        path.close()
        
        return view.addShapeLayer(path)
    }
    
    private func addLinesLayer(view: ShapeView, points:[(CGFloat, CGFloat)], color:UIColor) -> CAShapeLayer {
        let layer = addLinesLayer(view, points:points)
        layer.strokeColor = color.CGColor
        return layer
    }
    
}
