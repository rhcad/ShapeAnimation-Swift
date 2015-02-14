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
    
    @IBOutlet weak var animationView: ShapeView!
    var animationBlock : AnimationBlock?
    var data : AnyObject?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        animationBlock?(view: animationView)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        animationBlock = nil
        data = nil
    }
    
    @IBAction func stop(sender: AnyObject) {
        animationView.stop()
    }
    
    @IBAction func pause(sender: UIBarButtonItem) {
        animationView.paused = !animationView.paused
    }
}
