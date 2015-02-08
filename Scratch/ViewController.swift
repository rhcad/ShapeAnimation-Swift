//
//  ViewController.swift
//  Scratch
//
//  Created by Zhang Yungui on 2/7/15.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import ShapeAnimation
import SwiftGraphics

class ViewController: UIViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shapeView: ShapeView!
    
    var gestureHandler:GestureHandler!
    var selection:[CALayer] = []
    var selectionBorderLayer:AnimationLayer!
    var selectionMarquee = SelectionMarquee()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shapeView.style.lineWidth = 3
        
        gestureHandler = GestureHandler(view:shapeView)
        gestureHandler.panHandler = SelectHandler()
        
        selectionMarquee.active = true
        selectionMarquee.layer.fillColor = nil
        selectionMarquee.layer.strokeColor = nil
        
        selectionBorderLayer = addSelectionBorderLayer()
    }
    
    // MARK: Actions
    
    @IBAction func onLine(sender: AnyObject) {
        let points = arrayOfRandomPoints(2, shapeView.bounds)
        shapeAdded(shapeView.addLinesLayer(points))
        selectionMarquee.panLocation = points[0]
        selectionMarquee.panLocation = points[1]
    }
    
    @IBAction func onLines(sender: AnyObject) {
        let n = Random.rng.random(3..<6)
        shapeAdded(shapeView.addLinesLayer(arrayOfRandomPoints(n, shapeView.bounds)))
    }
    
    @IBAction func onTriangle(sender: AnyObject) {
        shapeAdded(shapeView.addLinesLayer(arrayOfRandomPoints(3, shapeView.bounds), closed:true))
    }
    
    @IBAction func onRect(sender: AnyObject) {
        let pt = Random.rng.random(shapeView.bounds)
        let size = Random.rng.random(CGRect(x:10, y:10, width:400, height:400))
        let rect = Rectangle(frame:CGRect(center:pt, size:CGSize(w:size.x, h:size.y)))
        shapeAdded(shapeView.addShapeLayer(rect.cgpath))
    }
    
    @IBAction func onPolygon(sender: AnyObject) {
        let n = Random.rng.random(3..<17), r = Random.rng.random(5..<200)
        let pt = Random.rng.random(shapeView.bounds)
        shapeAdded(shapeView.addRegularPolygonLayer(n, center:pt, radius:CGFloat(r)))
    }
    
    @IBAction func onCircle(sender: AnyObject) {
        let pt = Random.rng.random(shapeView.bounds)
        shapeAdded(shapeView.addCircleLayer(center:pt, radius:CGFloat(Random.rng.random(5..<200))))
    }
    
    @IBAction func onEllipse(sender: AnyObject) {
        let pt = Random.rng.random(shapeView.bounds)
        let size = Random.rng.random(CGRect(x:10, y:10, width:400, height:400))
        shapeAdded(shapeView.addShapeLayer(Ellipse(center:pt, size:CGSize(w:size.x, h:size.y)).cgpath))
    }
    
    func addSelectionBorderLayer() -> AnimationLayer {
        let layer = shapeView.addAnimationLayer(frame:shapeView.bounds, properties:[("phase", 0)]) {
            (layer, ctx) -> Void in
            ctx.lineDash = [5, 5]
            ctx.lineDashPhase = layer.getProperty("phase")
            if self.selectionMarquee.layer.path != nil {
                ctx.strokePath(self.selectionMarquee.layer.path)
            }
        }
        layer.animationCreated = {
            $1.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
            $1.repeatCount=HUGE
        }
        
        layer.setProperty(20, key: "phase")
        return layer
    }
    
    @IBAction func onSelect(sender: AnyObject) {
        selection.removeAll()
    }
    
    class SelectHandler:PanHandler {
        
        func touchBegan(point:CGPoint) {
            
        }
        
        func touchMoved(point:CGPoint) {
            
        }
        
        func touchEnded(point:CGPoint) {
            
        }
    }
    
    @IBAction func onErase(sender: AnyObject) {
    }
    
    // MARK: Animations
    
    func shapeAdded(layer:CAShapeLayer) {
        func part() -> CGFloat { return Random.rng.random(CGFloat(1)) }
        layer.strokeColor = CGColor.color(red:part(), green:part(), blue:part(), alpha:max(0.4, part()))
        layer.strokeEndAnimation().apply(duration:0.2)
    }
}
