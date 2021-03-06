//
//  MXCILiquidFilter.h
//  LiquidKit
//
//  Created by Kevin Hartman on 2/1/14.
//  Copyright (c) 2014 Kevin Hartman (kevin@hart.mn), Joshua Pueschel (joshuapueschel@gmail.com),
//  Andrew Landman (anl8094@rit.edu).
//
//  Licensed under the MIT license.
//

#import <CoreImage/CoreImage.h>
#import "LQKLiquidEffect.h"

@interface LQKCILiquidFilter: CIFilter {
    CIImage *inputImage;
}

@property (retain, nonatomic) CIImage *inputImage;

@property CIFilter *threshFilter;
@property CIFilter *compositeFilter;
@property CIFilter *blurFilter;
@property CIImage *backgroundColor;

@property CGFloat blurRadius;
@property NSObject<LQKLiquidEffect> *liquidEffect;

- (id) initWithBlurRadius:(CGFloat)blurRadius withLiquidEffect:(NSObject<LQKLiquidEffect>*)liquidEffect;

@end

