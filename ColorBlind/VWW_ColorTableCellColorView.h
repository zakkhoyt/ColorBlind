//
//  VWW_ColorTableCellColorView.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/29/12.
//
//

#import <UIKit/UIKit.h>

@class VWW_ColorTableCellColorView;

@protocol VWW_ColorTableCellColorViewDelegate <NSObject>
-(void)vww_ColorTableCellColorView:(VWW_ColorTableCellColorView*)sender userSelectedColor:(UIColor*)color;
@end

@interface VWW_ColorTableCellColorView : UIView
@property (nonatomic, assign) id <VWW_ColorTableCellColorViewDelegate> delegate;
@end
