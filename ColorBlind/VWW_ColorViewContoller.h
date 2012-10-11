//
//  VWW_ColorViewContoller.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/23/12.
//
//

#import <UIKit/UIKit.h>
#import "VWW_Color.h"


@protocol VWW_ColorViewControllerDelegate <NSObject>
-(void)userIsDone;
@end

@interface VWW_ColorViewContoller : UIViewController
@property (nonatomic, retain) VWW_Color* color;
@property (nonatomic, assign) id <VWW_ColorViewControllerDelegate> delegate;
@end
