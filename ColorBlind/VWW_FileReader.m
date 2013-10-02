//
//  VWW_FileReader.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import "VWW_FileReader.h"

@interface VWW_FileReader ()
@end

@implementation VWW_FileReader

#pragma mark Custom methods

+(NSMutableArray*)colorsFromFile:(NSString*)path{
    const NSUInteger kArraySize = 1024;
    const NSUInteger kNameIndex = 0;
    const NSUInteger kHexIndex = 1;
    const NSUInteger kRedIndex = 2;
    const NSUInteger kGreenIndex = 3;
    const NSUInteger kBlueIndex = 4;
    const NSUInteger kHueIndex = 5;
    const NSUInteger kNumOfElementsPerLine = 6;

    NSMutableArray* colors = [[[NSMutableArray alloc]initWithCapacity:kArraySize]autorelease];
    NSError* error = nil;
    
    NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:&error];
    
    NSArray* lines = [fileContents componentsSeparatedByString:@"\n"];
    
    // Each line in the file will look like this:
    // "name, hex, red, green, blue, hue"
    // And with values:
    // string, string, 0-100, 0-100, 0-100, 0-255
    for(NSString* line in lines){
        NSArray* elements = [line componentsSeparatedByString:@","];
        
        if(elements.count != kNumOfElementsPerLine){
            continue;
        }
        
        NSString* name =    (NSString*)elements[kNameIndex];
        NSString* hex =     (NSString*)elements[kHexIndex];
        NSNumber* red =     (NSNumber*)elements[kRedIndex];
        NSNumber* green =   (NSNumber*)elements[kGreenIndex];
        NSNumber* blue =    (NSNumber*)elements[kBlueIndex];
        NSNumber* hue =     (NSNumber*)elements[kHueIndex];

        // Create VWW_Color object with convenience method
        VWW_Color* color = [[VWW_Color alloc]initWithName:name hex:hex red:red green:green blue:blue hue:hue];
        [colors addObject:color];
        [color release];
     
        // check if we have reached our array capacity
        if(colors.count >= kArraySize){
            break;
        }
    }
    
    NSLog(@"loaded %d colors from colors.csv", colors.count);
    return colors;
}


@end
