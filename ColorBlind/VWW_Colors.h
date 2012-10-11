//
//  VWW_Colors.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/23/12.
//
//

#import <Foundation/Foundation.h>
#import "VWW_Color.h"
#import "VWW_ColorsProtocol.h"

@interface VWW_Colors : NSObject

// TODO: convert this NSMutableArray to NSDictionary. With large input files,
// we are experiencing slow performance at points in the program.

@property (nonatomic, retain) NSMutableArray* colors;

// Returns a VWW_Color at index number index
-(VWW_Color*)colorAtIndex:(NSUInteger)index;

// Returns a VWW_Color in self.colors that most closely matches red green blue
-(VWW_Color*)colorFromRed:(NSNumber*)red Green:(NSNumber*)green Blue:(NSNumber*)blue;

// Returns the closest opposite of currentColor. Math is done on r, g, b
-(VWW_Color*)complimentColor;

// Returns the number of VWW_Color instances in our NSMutableArray colors
-(NSUInteger)count;

// Returns the currently selected color (defaults to first in list until set by calling this method)
-(VWW_Color*)currentColor;

// Returns a random VWW_Color from our NSMutableArray colors
-(VWW_Color*)randomColor;

// Sets the currentColor by color.name. Returns nil if no match is found.
-(bool)setCurrentColor:(VWW_Color*)newColor;

// Sets thh currentColor by iterating and comparing color.color (a UIColor property)
-(bool)setCurrentColorFromUIColor:(UIColor*)newColor;

@end
