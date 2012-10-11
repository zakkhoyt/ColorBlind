//
//  VWW_Color.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import <Foundation/Foundation.h>

@interface VWW_Color : NSObject

@property (nonatomic, retain) NSString* name; 
@property (nonatomic, retain) NSString* hex; 
@property (nonatomic, retain) NSNumber* red;
@property (nonatomic, retain) NSNumber* green;
@property (nonatomic, retain) NSNumber* blue;
@property (nonatomic, retain) NSNumber* hue;
@property (nonatomic, retain) UIColor*  color;


-(id)initWithName:(NSString*)name 
              hex:(NSString*)hex
              red:(NSNumber*)red
            green:(NSNumber*)green
             blue:(NSNumber*)blue
              hue:(NSNumber*)hue;

-(NSString*)description;

@end
