//
//  VWW_ColorPickerImageView.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/20/12.
//
//

#import <UIKit/UIKit.h>
#import "VWW_Colors.h"

@class VWW_ColorPickerImageView;

@protocol VWW_ColorPickerImageViewDelegate <NSObject>
-(void)vww_ColorPickerImageView:(VWW_ColorPickerImageView*)sender userSelectedPixel:(CGPoint)pixel withColor:(VWW_Color*)color;
-(void)vww_ColorPickerImageViewUserDoubleTapped:(VWW_ColorPickerImageView*)sender;
@end

@interface VWW_ColorPickerImageView : UIImageView
@property (nonatomic, retain) VWW_Colors* colors;
@property (nonatomic, assign) id <VWW_ColorPickerImageViewDelegate> delegate;
@end
