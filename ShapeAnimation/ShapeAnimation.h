//
//  ShapeAnimation.h
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/1/20.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for ShapeAnimation.
FOUNDATION_EXPORT double ShapeAnimationVersionNumber;

//! Project version string for ShapeAnimation.
FOUNDATION_EXPORT const unsigned char ShapeAnimationVersionString[];

// In this header, you should import all the public headers of your framework to import ObjC code into Swift.

#import "SVGKImage.h"
#import "SVGKParser.h"
#import "SVGKSource.h"
#import "SVGKLayer.h"
#import "CALayerExporter.h"
#import "SVGKExporterNSData.h"
#import "SVGKExporterUIImage.h"
#import "SVGKImage+CGContext.h"

// Adding Try-Catch to Swift. Modified from https://github.com/williamFalcon/SwiftTryCatch
@interface TryCatch : NSObject
//! Provides try catch functionality for swift by wrapping around Objective-C
+ (void)try:(void(^)())try catch:(void(^)(NSException*exception))catch finally:(void(^)())finally;
+ (void)try:(void(^)())try catch:(void(^)(NSException*exception))catch;
+ (void)throwString:(NSString*)s;
+ (void)throwException:(NSException*)e;
@end
