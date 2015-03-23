//
//  Portability.swift
//  SwiftAnimShape
//
//  Created by Zhang Yungui on 15/3/19.
//  Copyright (c) 2015 github.com/touchvg. All rights reserved.
//

#if os(OSX)
import Cocoa
    public typealias ViewController     = NSViewController
    public typealias View               = NSView
    public typealias Image              = NSImage
    public typealias Font               = NSFont
    public typealias GestureRecognizer  = NSGestureRecognizer
    public typealias TapRecognizer      = NSClickGestureRecognizer
    public typealias PanRecognizer      = NSPanGestureRecognizer
    public typealias Button             = NSButton
#else
import UIKit
    public typealias ViewController     = UIViewController
    public typealias View               = UIView
    public typealias Image              = UIImage
    public typealias Font               = UIFont
    public typealias GestureRecognizer  = UIGestureRecognizer
    public typealias TapRecognizer      = UITapGestureRecognizer
    public typealias PanRecognizer      = UIPanGestureRecognizer
    public typealias Button             = UIButton
#endif
