//
//  DetailViewController.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/15.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import ShapeAnimation

typealias AnimationBlock = ((view:ShapeView) -> Void)

class DetailViewController: UIViewController {
    
    @IBOutlet var animationView: ShapeView!
    var animationBlock : AnimationBlock?
    var data : AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationBlock?(view: animationView)
    }
    
    @IBAction func stop(sender: AnyObject) {
        animationView.removeAllAnimations()
    }
    
    @IBAction func pause(sender: UIBarButtonItem) {
        animationView.paused = !animationView.paused
    }
}
