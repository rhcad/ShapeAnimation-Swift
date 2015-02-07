//
//  ShapeView+Image.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/3.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics

public extension ShapeView {
    
    public func addSVGLayer(image:SVGKImage!, maxSize:CGSize) -> SVGKLayer {
        let orgsize = image.size
        if orgsize.width > maxSize.width || orgsize.height > maxSize.height {
            let scale = min(maxSize.width / orgsize.width, maxSize.height / orgsize.height)
            image.scaleToFitInside(orgsize * scale)
        }
        let frame = CGRect(w:round(image.size.width), h:round(image.size.height))
        let layer = SVGKLayer()
        layer.SVGImage = image
        self.addSublayer(layer, frame:frame)
        return layer
    }
    
    public func addSVGLayer(#named:String, maxSize:CGSize) -> SVGKLayer? {
        var ret:SVGKLayer?
        TryCatch.try( {
            if let image = SVGKImage(named:named) {
                ret = self.addSVGLayer(image, maxSize:maxSize)
            }
        }, catch: {
            println($0.reason)
        })
        return ret
    }
    
    public func addSVGLayer(contentsOfFile path:String, maxSize:CGSize) -> SVGKLayer? {
        var ret:SVGKLayer?
        TryCatch.try( {
            if let image = SVGKImage(contentsOfFile:path) {
                ret = self.addSVGLayer(image, maxSize:maxSize)
            }
        }, catch: {
            println($0.reason)
        })
        return ret
    }
    
}

private func convertSVGToImage(image:SVGKImage, maxSize:CGSize) -> UIImage {
    let orgsize = image.size
    if orgsize.width > maxSize.width || orgsize.height > maxSize.height {
        image.scaleToFitInside(maxSize)
    }
    return SVGKExporterUIImage.exportAsUIImage(image)
}

public func convertSVGToImage(named:String, maxSize:CGSize) -> UIImage? {
    var ret:UIImage?
    TryCatch.try( {
        if let image = SVGKImage(named:named) {
            ret = convertSVGToImage(image, maxSize)
        }
    }, catch: {
        println($0.reason)
    })
    return ret
}

public func convertSVGFileToImage(path:String, maxSize:CGSize) -> UIImage? {
    var ret:UIImage?
    TryCatch.try( {
        if let image = SVGKImage(contentsOfFile:path) {
            ret = convertSVGToImage(image, maxSize)
        }
    }, catch: {
        println($0.reason)
    })
    return ret
}
