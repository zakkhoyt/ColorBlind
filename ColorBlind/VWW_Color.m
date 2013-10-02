//
//  VWW_Color.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import "VWW_Color.h"
#import "NSNumber+htmlValue.h"

@interface VWW_Color ()
@end

@implementation VWW_Color
- (void)dealloc
{
    [_name release];
    [_hex release];
    [_red release];
    [_green release];
    [_blue release];
    [_hue release];
    [_color release];
    
    [super dealloc];
}


#pragma mark Custom methods

-(id)initWithName:(NSString*)name
              hex:(NSString*)hex
              red:(NSNumber*)red
            green:(NSNumber*)green
             blue:(NSNumber*)blue
              hue:(NSNumber*)hue{
    
    self = [super init];
    if(self){
        _name = name;
        _hex = hex;
        _red = red;
        _green = green;
        _blue = blue;
        _hue = hue;
        _color = [UIColor colorWithRed:self.red.intValue/100.0f green:self.green.intValue/100.0f blue:self.blue.intValue/100.0f alpha:1.0];
        
        // must retain each property so that it doesn't disappear out from under us.
        [_name retain];
        [_hex retain];
        [_red retain];
        [_green retain];
        [_blue retain];
        [_hue retain];
        [_color retain];
    }
    return self;
}

-(NSString*)description{
    NSString* colorDescription = [NSString stringWithFormat:@"hex:#%@\nred:%d\ngreen:%d\nblue:%d",
                                 self.hex,
                                 self.red.integerValue,
                                 self.green.integerValue,
                                 self.blue.integerValue];
    return  colorDescription;
    
}


@end
