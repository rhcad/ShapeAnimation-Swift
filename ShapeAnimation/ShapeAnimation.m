//
//  ShapeAnimation.m
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/4.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

#import "ShapeAnimation.h"

// Adding Try-Catch to Swift. Modified from https://github.com/williamFalcon/SwiftTryCatch
@implementation TryCatch

+ (void)try:(void (^)())try catch:(void (^)(NSException *))catch finally:(void (^)())finally {
    @try {
        try ? try() : nil;
    }
    @catch (NSException *exception) {
        catch ? catch(exception) : nil;
    }
    @finally {
        finally ? finally() : nil;
    }
}

+ (void)try:(void (^)())try catch:(void (^)(NSException *))catch {
    [TryCatch try:try catch:catch finally:nil];
}

+ (void)throwString:(NSString*)s {
    @throw [NSException exceptionWithName:s reason:s userInfo:nil];
}

+ (void)throwException:(NSException*)e {
    @throw e;
}

@end
