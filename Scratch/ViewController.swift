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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shapeView.style.lineWidth = 3
    }
    
    // MARK: Actions
    
    @IBAction func onSelect(sender: AnyObject) {
    }
    
    @IBAction func onLine(sender: AnyObject) {
        let layer = shapeView.addLinesLayer(arrayOfRandomPoints(2, shapeView.bounds))
        strokeEndAnimation(layer)
    }
    
    @IBAction func onLines(sender: AnyObject) {
        let n = Random.rng.random(3..<6)
        let layer = shapeView.addLinesLayer(arrayOfRandomPoints(n, shapeView.bounds))
        strokeEndAnimation(layer)
    }
    
    @IBAction func onTriangle(sender: AnyObject) {
        let layer = shapeView.addLinesLayer(arrayOfRandomPoints(3, shapeView.bounds), closed:true)
        strokeEndAnimation(layer)
    }
    
    @IBAction func onRect(sender: AnyObject) {
        let pt = Random.rng.random(shapeView.bounds)
        let size = Random.rng.random(CGRect(x:10, y:10, width:400, height:400))
        let rect = Rectangle(frame:CGRect(center:pt, size:CGSize(w:size.x, h:size.y)))
        let layer = shapeView.addShapeLayer(rect.cgpath)
        strokeEndAnimation(layer)
    }
    
    @IBAction func onPolygon(sender: AnyObject) {
        let n = Random.rng.random(3..<17), r = Random.rng.random(5..<200)
        let pt = Random.rng.random(shapeView.bounds)
        let layer = shapeView.addRegularPolygonLayer(n, center:pt, radius:CGFloat(r))
        strokeEndAnimation(layer)
    }
    
    @IBAction func onCircle(sender: AnyObject) {
        let pt = Random.rng.random(shapeView.bounds)
        let layer = shapeView.addCircleLayer(center:pt, radius:CGFloat(Random.rng.random(5..<200)))
        strokeEndAnimation(layer)
    }
    
    @IBAction func onEllipse(sender: AnyObject) {
        let pt = Random.rng.random(shapeView.bounds)
        let size = Random.rng.random(CGRect(x:10, y:10, width:400, height:400))
        let ellipse = Ellipse(center:pt, size:CGSize(w:size.x, h:size.y))
        let layer = shapeView.addShapeLayer(ellipse.cgpath)
        strokeEndAnimation(layer)
    }
    
    @IBAction func onErase(sender: AnyObject) {
    }
    
    // MARK: Animations
    
    func strokeEndAnimation(layer:CAShapeLayer) {
        func part() -> CGFloat { return Random.rng.random(CGFloat(1)) }
        layer.strokeColor = CGColor.color(red:part(), green:part(), blue:part(), alpha:max(0.4, part()))
        layer.strokeEndAnimation().apply(duration:0.3)
    }
}
