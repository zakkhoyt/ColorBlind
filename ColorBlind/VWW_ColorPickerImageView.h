//
//  VWW_ColorPickerImageView.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/20/12.
//
//

#import <UIKit/UIKit.h>
#import "VWW_Colors.h"

@protocol VWW_ColorPickerImageViewDelegate <NSObject>
-(void)userSelectedPixel:(CGPoint)pixel withColor:(VWW_Color*)color;
-(void)userDoubleTapped;
@end

@interface VWW_ColorPickerImageView : UIImageView
@property (nonatomic, retain) VWW_Colors* colors;
@property (nonatomic, assign) id <VWW_ColorPickerImageViewDelegate> delegate;
@end
