//
//  DetailViewController.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/15.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import UIKit
import ShapeAnimation

class DetailViewController: UIViewController {
    
    @IBOutlet var animationView: ShapeView?
    var animationBlock : ((view:ShapeView) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationBlock?(view: animationView!)
    }
    
}
