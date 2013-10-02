//
//  VWW_Colors.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/23/12.
//
//

#import "VWW_Colors.h"
#import "VWW_FileReader.h"

@interface VWW_Colors (){
    // We need to write our own setter/getter for this class
    // See setter/getter declaration below
    VWW_Color* _currentColor;
}

@end

@implementation VWW_Colors



-(id)init{
    self = [super init];
    if(self){
        NSString* path = [[NSBundle mainBundle] pathForResource:@"colors_complex" ofType:@"csv"];
        self.colors = [VWW_FileReader colorsFromFile:path];
        if(self.colors && self.colors.count > 0){
            self.currentColor = (VWW_Color*)(self.colors)[0];
        }
        else{
            NSLog(@"ERROR at %s:%d", __FUNCTION__, __LINE__);
            NSString* strError = @"Failed to load colors file";
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error" message:strError delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"okay", nil];
            [alert show];
            return nil;
        }
            
    }
    else{
        NSLog(@"ERROR at %s:%d", __FUNCTION__, __LINE__);
    }
    return self;
}

-(void)dealloc{

    [super dealloc];
}

-(VWW_Color*)colorAtIndex:(NSUInteger)index{
    if(!self.colors){
        NSLog(@"ERROR at %s:%d", __FUNCTION__, __LINE__);
        return nil;
    }

    if(index > self.colors.count){
        return nil;
    }
    else{
        return (self.colors)[index];
    }
}


-(VWW_Color*)colorFromRed:(NSNumber*)red Green:(NSNumber*)green Blue:(NSNumber*)blue{
    if(!self.colors){
        NSLog(@"ERROR at %s:%d", __FUNCTION__, __LINE__);
        return nil;
    }

    NSUInteger closestIndex = 0;
    NSUInteger smallestDifference = 300; // 100+100+100 is the largest possible difference
    
    for(NSUInteger index = 0; index < self.colors.count; index++){
        VWW_Color* color = (self.colors)[index];
        NSUInteger diffRed = abs(color.red.integerValue - red.integerValue);
        NSUInteger diffGreen = abs(color.green.integerValue - green.integerValue);
        NSUInteger diffBlue = abs(color.blue.integerValue - blue.integerValue);
        if(diffRed + diffGreen + diffBlue < smallestDifference){
            smallestDifference = diffRed + diffGreen + diffBlue;
            closestIndex = index;
        }
    }
    
    return (VWW_Color*)(self.colors)[closestIndex];
    
}

-(NSUInteger)count{
    if(!self.colors){
        NSLog(@"ERROR at %s:%d", __FUNCTION__, __LINE__);
        return 0;
    }
    return self.colors.count;
}



-(VWW_Color*)currentColor{
    if(!_currentColor){
        NSLog(@"ERROR at %s:%d", __FUNCTION__, __LINE__);
        return nil;
    }
    return (VWW_Color*)_currentColor;
}


-(VWW_Color*)complimentColor{
    // TODO: implement
    return self.currentColor;
}



-(VWW_Color*)randomColor{
    if(!self.colors){
        NSLog(@"ERROR at %s:%d", __FUNCTION__, __LINE__);
        return 0;
    }
    
    int r = arc4random() % self.colors.count;
    return (VWW_Color*)(self.colors)[r];
}



// Loop through our array of VWW_Color objects and do a case insensitive compare on the name property
// Also dispatch a Notification Center event
-(bool)setCurrentColor:(VWW_Color*)newColor{
    if(!self.colors){
        NSLog(@"ERROR at %s:%d", __FUNCTION__, __LINE__);
        return NO;
    }

    for(NSUInteger index = 0; index < self.colors.count; index++){
        VWW_Color* color = (self.colors)[index];
        if([color.name caseInsensitiveCompare:newColor.name] == NSOrderedSame){
            [_currentColor release];
            _currentColor = color;
            [_currentColor retain];

            // Stuff color into an NSDictionary and sent it along with the notification. 
            NSDictionary *userInfo = @{@"currentColor": _currentColor};
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%s", NC_CURRENT_COLOR_CHANGED] object:self userInfo:userInfo];
            return YES;
        }
    }
    
    // we never found color in our list of colors. Return NO;
    return NO;
}

// Loop through our array of VWW_Color objects and compare normalized RGB properties
// Also dispatch a Notification Center event
-(bool)setCurrentColorFromUIColor:(UIColor*)newColor{
    if(!self.colors){
        NSLog(@"ERROR at %s:%d", __FUNCTION__, __LINE__);
        return NO;
    }
    
    for(NSUInteger index = 0; index < self.colors.count; index++){
        VWW_Color* color = (self.colors)[index];

        CGFloat red = 0.0f;
        CGFloat green = 0.0f;
        CGFloat blue = 0.0f;
        CGFloat alpha = 0.0f;
        
        if(![newColor getRed:&red green:&green blue:&blue alpha:&alpha]){
            // Error occured getting rgba. Fail silently
            continue;
        }

// TODO: BUG: color "Asparagus" fails to function here
//        NSLog(@"%d=%d\t%d=%d\t%d=%d",
//              (NSUInteger)(red*100), color.red.integerValue,
//              (NSUInteger)(green*100), color.green.integerValue,
//              (NSUInteger)(blue*100), color.blue.integerValue);
        
        // local vars are 0.0 - 1.0
        // color.(vars) are 0 - 100.
        // Normalize and compare. Disregard alpha
        if((NSUInteger)(red*100) == color.red.integerValue &&
           (NSUInteger)(green*100) == color.green.integerValue &&
           (NSUInteger)(blue*100) == color.blue.integerValue){

            [_currentColor release];
            _currentColor = color;
            [_currentColor retain];
            
            // Stuff color into an NSDictionary and sent it along with the NSNotification.
            NSDictionary *userInfo = @{@"currentColor": _currentColor};
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%s", NC_CURRENT_COLOR_CHANGED] object:self userInfo:userInfo];
            return YES;
        }
    }
    
    // we never found color in our list of colors. Return NO;
    return NO;
}





@end
