//
//  VWW_ColorPickerView.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/19/12.
//
//

#import "VWW_ColorPickerView.h"

@implementation VWW_ColorPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// This code is probably no longer needed as we are getting our gradient from an image now. 
//- (void)drawRect:(CGRect)rect
//{
//    // This will render a gradient onto our control
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
//    
//    size_t num_locations = 4;
//    CGFloat locations[4] = { 0.0, 0.33, 0.66, 1.0 };
//    CGFloat components[16] = {  1.0, 0.0, 0.0, 1.0,     // first color
//                                0.0, 1.0, 0.0, 1.0,     // second color
//                                0.0, 0.0, 1.0, 1.0,     // third color
//                                1.0, 0.0, 0.0, 1.0,};   // fourth color
//    CGGradientRef glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
//
//    // Draw a 4 color gradient from left to right
//    CGPoint topCenter = CGPointMake(0.0f, 0.0f);
//    CGPoint midCenter = CGPointMake(self.bounds.size.width, 0);
//    CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
//    
//    // As per the CF naming conventions, any object obtaines with "Create" or "Copy" must be released
//    CGGradientRelease(glossGradient);
//    CGColorSpaceRelease(rgbColorspace);
// 
//}

#pragma mark UIView touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.delegate vww_ColorPickerView:self userSelectedColor:self.backgroundColor];
}

/*
 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
 }
 
 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
 }
 */

#pragma mark Custom methods

@end
