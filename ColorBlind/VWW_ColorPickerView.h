//
//  VWW_ColorPickerView.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/19/12.
//
//

#import <UIKit/UIKit.h>



@protocol VWW_ColorPickerViewDelegate <NSObject>
-(void)userSelectedColor:(UIColor*)color;
@end








@interface VWW_ColorPickerView : UIView
@property (nonatomic, assign) id <VWW_ColorPickerViewDelegate> delegate;
@end
