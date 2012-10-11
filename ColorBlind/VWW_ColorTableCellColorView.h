//
//  VWW_ColorTableCellColorView.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/29/12.
//
//

#import <UIKit/UIKit.h>

@protocol VWW_ColorTableCellColorViewDelegate <NSObject>
-(void)userSelectedColor:(UIColor*)color;
@end

@interface VWW_ColorTableCellColorView : UIView
@property (nonatomic, assign) id <VWW_ColorTableCellColorViewDelegate> delegate;
@end
