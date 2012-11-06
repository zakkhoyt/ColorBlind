//
//  VWW_ColorsCameraPreviewView.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/27/12.
//
//

#import "VWW_ColorsCameraPreviewView.h"

@interface VWW_ColorsCameraPreviewView ()
@property bool isUsingRetinaDisplay;
-(VWW_Color*)getColorOfPixelAtPoint:(CGPoint)point;
-(bool)hasRetinaDisplay;
-(void)touchEvent:(NSSet *)touches withEvent:(UIEvent *)event;
//- (UIImage *)imageFromLayer:(CALayer *)layer;
@end

@implementation VWW_ColorsCameraPreviewView
@synthesize colors = _colors;


//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.isUsingRetinaDisplay = [self hasRetinaDisplay];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark UIView touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchEvent:touches withEvent:event];
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
//    int x = point.x;
//    int y = point.y;
//    
//    // If the user has a retina display, UIImageView automatically scales the image by 200% each axis.
//    // Since we have twice as big of an index, we need to scale our pointers.
//    if(self.isUsingRetinaDisplay){
//        // BUG: Whenever y is an odd number, the returned color is incorrect.
//        // It *looks* like it's retreiveing the color from twice the x position over.
//        x = floor(point.x * 2);
//        y = floor(point.y * 2);
//        if(x % 2 != 0) x-=1;
//        if(y % 2 != 0) y-=1;
//    }
//    
//    
//    //UIImage* image = self.image;
//    
//
////    NSArray* layers = [self.layer sublayers];
////    CALayer* camPreviewLayer = [layers objectAtIndex:0];
////    
////
////    UIGraphicsBeginImageContext([camPreviewLayer frame].size);
//
////    [camPreviewLayer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
//    const UInt8* data = CFDataGetBytePtr(pixelData);
//    int pixelIndex = ((image.size.width * y) + x) * 4;
//    UInt8 red = data[pixelIndex];
//    UInt8 green = data[(pixelIndex + 1)];
//    UInt8 blue = data[pixelIndex + 2];
//    //    UInt8 alpha = data[pixelIndex + 3];   // Not used in this method. Leaving in for reference
//    
//    //    NSLog(@"w=%d h=%d x=%d y=%d r=%x g=%x b=%x", (int)image.size.width, (int)image.size.height, x, y, red, green, blue);
//    
//    // Our rgb data is currently 0.0-1.0. Cast to 0-100
//    VWW_Color* color = [self.colors colorFromRed:[NSNumber numberWithInteger:(NSUInteger)red*(100/255.0)]
//                                           Green:[NSNumber numberWithInteger:(NSUInteger)green*(100/255.0)]
//                                            Blue:[NSNumber numberWithInteger:(NSUInteger)blue*(100/255.0)]];
//    // Tell our delegate of the color at pixel
//    if(self.delegate){
//        [self.delegate userSelectedPixel:point withColor:color];
//    }
//    
//    CFRelease(pixelData);
//    
//    return color;
//    


    
    
    
//    
//    // TEMP: This is just soem junk to return for now. 
    VWW_Color* color = self.colors.currentColor;
    // Tell our delegate of the color at pixel
    if(self.delegate){
        [self.delegate vww_ColorsCameraPreviewView:self userSelectedPixel:point withColor:color];
    }


    return color;

}


//- (UIImage *)imageFromLayer:(CALayer *)layer
//{
//    UIGraphicsBeginImageContext([layer frame].size);
//
//    [layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return outputImage;
//}
//




@end
