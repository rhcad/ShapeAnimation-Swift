//
//  ShapeView+Image.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/3.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

public extension ShapeView {
    
    public func addTextLayer(text:String, frame:CGRect, fontSize:CGFloat) -> CATextLayer {
        let layer = CATextLayer()
        
        layer.string = text
        layer.fontSize = fontSize
        if let strokeColor = style.strokeColor {
            layer.foregroundColor = strokeColor
        }
        layer.alignmentMode = kCAAlignmentCenter
        layer.wrapped = true
        self.addSublayer(layer, frame:frame)
    
        return layer
    }
    
    public func addImageLayer(image:UIImage!, center:CGPoint) -> CALayer {
        let layer = CALayer()
        layer.contents = image.CGImage
        self.addSublayer(layer, frame:CGRect(center:center, size:image.size))
        return layer
    }
    
    public func addImageLayer(#named:String, center:CGPoint) -> CALayer? {
        if let image = UIImage(named:named) {
            return self.addImageLayer(image, center:center)
        }
        return nil
    }
    
    public func addImageLayer(contentsOfFile path:String, center:CGPoint) -> CALayer? {
        if let image = UIImage(contentsOfFile:path) {
            return self.addImageLayer(image, center:center)
        }
        return nil
    }
}
