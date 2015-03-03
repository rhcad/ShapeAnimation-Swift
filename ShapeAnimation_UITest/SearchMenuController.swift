//
//  SearchMenuController.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/3.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics
import ShapeAnimation

// Searching menu animation like https://github.com/kongnanlive/SearchMenuAnim
class SearchMenuController: DetailViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var srearchButton: UIButton!
    let pathLayer = CAShapeLayer()
    var offsetDist:CGFloat!
    var joinParam:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.borderStyle = .None
        textField.hidden = true
        textField.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:textField, action:"resignFirstResponder"))
        
        let path1 = "M15.3,15.3 A9 9 0 0 1 2.6 2.6,9 9 0 0 1 15.3,15.3L21,21"
        pathLayer.path = CGPathFromSVGPath(path1 + "h\(-textField.bounds.width)")
        offsetDist = textField.bounds.width / 2 - srearchButton.bounds.width / 2
        joinParam  = CGPathFromSVGPath(path1).length / pathLayer.path.length
        
        pathLayer.lineWidth = 1.5
        pathLayer.strokeColor = CGColor.whiteColor()
        pathLayer.fillColor = nil
        pathLayer.strokeEnd = joinParam
        srearchButton.layer.addSublayer(pathLayer)
    }
    
    @IBAction func searchButtonTapped(sender: UIButton) {
        textField.hidden = false
        srearchButton.enabled = false
        animationGroup([pathLayer.strokeStartAnimation(from:0, to:joinParam),
            pathLayer.strokeEndAnimation(from:joinParam, to:1),
            pathLayer.moveAnimation(from:nil, to:CGPoint(x:self.offsetDist))])
            .setFillMode(kCAFillModeForwards).apply() {
                self.textField.becomeFirstResponder(); return
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.hidden = true
        srearchButton.enabled = true
        animationGroup([pathLayer.strokeStartAnimation(from:joinParam, to:0),
            pathLayer.strokeEndAnimation(from:1, to:joinParam),
            pathLayer.moveAnimation(from:CGPoint(x:self.offsetDist), to:CGPoint.zeroPoint)]).apply()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
