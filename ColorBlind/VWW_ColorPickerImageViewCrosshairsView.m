//
//  VWW_ColorPickerImageViewCrosshairsView.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/27/12.
//
//

#import "VWW_ColorPickerImageViewCrosshairsView.h"

@interface VWW_ColorPickerImageViewCrosshairsView (){
    CGPoint _selectedPixel;
    
}
@end

@implementation VWW_ColorPickerImageViewCrosshairsView

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        _selectedPixel.x = 0.0f;
//        _selectedPixel.y = 0.0f;
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _selectedPixel.x = 0.0f;
        _selectedPixel.y = 0.0f;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{    
    // Don't draw a crosshair if the user hasn't touched yet.
    if(self.selectedPixel.x == 0 && self.selectedPixel.y == 0){
        return;
    }
    
    const int kCrosshairLength = 50;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGFloat color[4] = {1, 1, 1, 1};        // r,g,b,a
    CGContextSetStrokeColor(c, color);
    CGContextBeginPath(c);
    
    CGFloat startX = self.selectedPixel.x - (kCrosshairLength/2);
    if(startX < 0) startX = 0;
    
    CGFloat finishX = self.selectedPixel.x + (kCrosshairLength/2);
    if(finishX > self.bounds.size.width) finishX = self.bounds.size.width;

    CGFloat startY = self.selectedPixel.y - (kCrosshairLength/2);
    if(startY < 0) startY = 0;
    
    CGFloat finishY = self.selectedPixel.y + (kCrosshairLength/2);
    if(finishY > self.bounds.size.height) finishY = self.bounds.size.height;
    
//    NSLog(@"startX=%f x=%f finishX=%f startY=%f y=%f finishY=%f",
//          startX,
//          self.selectedPixel.x,
//          finishX,
//          startY,
//          self.selectedPixel.y,
//          finishY);
    
    // draw horiontal hair
    CGContextMoveToPoint(c,
                         startX,
                         self.selectedPixel.y);
    
    CGContextAddLineToPoint(c,
                            finishX,
                            self.selectedPixel.y);
    
    // draw vertical hair
    CGContextMoveToPoint(c,
                         self.selectedPixel.x,
                         startY);
    CGContextAddLineToPoint(c,
                            self.selectedPixel.x,
                            finishY);
    
    CGContextStrokePath(c);
}

#pragma mark Custom methods

@end
