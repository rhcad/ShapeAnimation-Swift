//
//  ShapeView+Image.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/3.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

public extension ShapeView {
    
    public func addRectangleLayer(frame:CGRect) -> CAShapeLayer! {
        return addShapeLayer(CGPathCreateWithRect(frame, nil))
    }
    
    public func addCircleLayer(center c:CGPoint, radius:CGFloat) -> CAShapeLayer! {
        return addShapeLayer(CGPathCreateWithEllipseInRect(CGRect(center:c, radius:radius), nil))
    }
    
    public func addRegularPolygonLayer(nside:Int, center:CGPoint, radius:CGFloat) -> CAShapeLayer! {
        return addLinesLayer(RegularPolygon(nside:nside, center:center, radius:radius).points, closed:true)
    }
    
    public func addLinesLayer(points:[CGPoint], closed:Bool = false) -> CAShapeLayer! {
        return addShapeLayer(Path(vertices:points, closed:closed).cgPath)
    }
    
    //! Add shape layer with path string as the ‘d’ attribute of SVG path.
    //! It can contain instructions ‘MmLlCcQqSsTtZz’ as described in http://www.w3.org/TR/SVGTiny12/paths.html
    public func addSVGPathLayer(d:String, position:CGPoint? = nil) -> CAShapeLayer! {
        return addShapeLayer(CGPathFromSVGPath(d), position:position)
    }
}

public extension ShapeView {
    
    public func addTextLayer(text:String, frame:CGRect, fontSize:CGFloat) -> CATextLayer! {
        let layer = CATextLayer()
        
        layer.string = text
        layer.fontSize = fontSize
        if let strokeColor = style.strokeColor {
            layer.foregroundColor = strokeColor
        }
        layer.alignmentMode = kCAAlignmentCenter
        layer.wrapped = true
        addSublayer(layer, frame:frame)
    
        return layer
    }
    
    public func addTextLayer(text:String, center:CGPoint, fontSize:CGFloat) -> CATextLayer! {
        let attr = [NSFontAttributeName: Font.systemFontOfSize(fontSize)]
        let size = text.sizeWithAttributes(attr)
        return addTextLayer(text, frame:CGRect(center:center, size:size), fontSize:fontSize)
    }
    
    public func addImageLayer(image:Image, center:CGPoint) -> CALayer! {
        let layer = CALayer()
#if os(iOS)
        layer.contents = image.CGImage
#else
        let ctx = NSGraphicsContext.currentContext()
        var rect = CGRect(size:image.size)
        layer.contents = image.CGImageForProposedRect(&rect, context:ctx, hints:nil)?.takeUnretainedValue()
#endif
        addSublayer(layer, frame:CGRect(center:center, size:image.size))
        return layer
    }
    
    public func addImageLayer(#named:String, center:CGPoint) -> CALayer? {
        if let image = Image(named:named) {
            return addImageLayer(image, center:center)
        }
        return nil
    }
    
    public func addImageLayer(contentsOfFile path:String, center:CGPoint) -> CALayer? {
        if let image = Image(contentsOfFile:path) {
            return addImageLayer(image, center:center)
        }
        return nil
    }
}
