//
//  VWW_ColorPickerImageViewCrosshairsView.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/27/12.
//
//  Since we cannot override drawRect in a UIImageView, we need to lay another UIView on top of said UIImageView
//  set it to be transparent and then render the crosshairs this way. That is the intent of this class

#import <UIKit/UIKit.h>

@interface VWW_ColorPickerImageViewCrosshairsView : UIView
@property (nonatomic, assign) CGPoint selectedPixel;
@end
