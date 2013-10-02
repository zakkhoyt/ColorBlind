//
//  VWW_ColorPickerImageView.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/20/12.
//
//

#import "VWW_ColorPickerImageView.h"

@interface VWW_ColorPickerImageView ()
@property bool isUsingRetinaDisplay;
-(VWW_Color*)getColorOfPixelAtPoint:(CGPoint)point;
-(bool)hasRetinaDisplay;
-(void)touchEvent:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@implementation VWW_ColorPickerImageView



- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.isUsingRetinaDisplay = [self hasRetinaDisplay];
    }
    return self;
}




#pragma mark UIView touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if(touch.tapCount == 2){
        [self.delegate vww_ColorPickerImageViewUserDoubleTapped:self];
    }
    else if(touch.tapCount == 1){
        [self touchEvent:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchEvent:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    // By setting the crosshairs pixels to 0,0, they will not be drawn
//    [self.delegate userSelectedPixel:CGPointMake(0, 0) withColor:self.colors.currentColor];
}

#pragma mark Custom methods

- (void)touchEvent:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    

    // This will catch if the user dragged their finger out of bounds of the UIImageView
    // Return so we dont' try to index outside of the images's memory
    if (!CGRectContainsPoint(self.bounds, point)){
        return;
    }
    
    [self getColorOfPixelAtPoint:point];
}

// Return YES if we're running on a device with a retina display.
-(bool)hasRetinaDisplay{
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        return [[UIScreen mainScreen] scale] == 2.0 ? YES : NO;
    }
    
    return NO;
}

// Examine the pixel under the user's finger to get the color
// This may not work for all image types. Confirmed with png.
-(VWW_Color*)getColorOfPixelAtPoint:(CGPoint)point{
    int x = point.x;
    int y = point.y;
    
    // If the user has a retina display, UIImageView automatically scales the image by 200% each axis.
    // Since we have twice as big of an index, we need to scale our pointers.
    if(self.isUsingRetinaDisplay){
        x *= 2;
        y *= 4; // Not sure why this is necessary?
    }
    
    
    
    UIImage* image = self.image;
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    int pixelIndex = ((image.size.width * y) + x) * 4;
    UInt8 red = data[pixelIndex];
    UInt8 green = data[(pixelIndex + 1)];
    UInt8 blue = data[pixelIndex + 2];
//    UInt8 alpha = data[pixelIndex + 3];   // Not used in this method. Leaving in for reference
    
//    NSLog(@"w=%d h=%d x=%d y=%d r=%x g=%x b=%x", (int)image.size.width, (int)image.size.height, x, y, red, green, blue);
    
    // Our rgb data is currently 0.0-1.0. Cast to 0-100
    VWW_Color* color = [self.colors colorFromRed:[NSNumber numberWithInteger:(NSUInteger)red*(100/255.0)]
                                                                         Green:[NSNumber numberWithInteger:(NSUInteger)green*(100/255.0)]
                                                                          Blue:[NSNumber numberWithInteger:(NSUInteger)blue*(100/255.0)]];
    // Tell our delegate of the color at pixel
    [self.delegate vww_ColorPickerImageView:self userSelectedPixel:point withColor:color];
    
    CFRelease(pixelData);
    
    return color;
}

@end
