//
//  NSNumber+hexValue.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import "NSNumber+htmlValue.h"

@implementation NSNumber (htmlValue)

#pragma mark Custom methods

-(NSString*)htmlValue{
    return [NSString stringWithFormat:@"%d", (NSUInteger)((self.integerValue / 100.0) * 255)];
}

@end
