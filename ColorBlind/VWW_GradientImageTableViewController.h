//
//  VWW_GradientImageTableViewController.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/29/12.
//
//

#import <UIKit/UIKit.h>

@class VWW_GradientImageTableViewController;

@protocol VWW_GradientImageTableViewDelegate <NSObject>
-(void)vww_GradientImageTableViewController:(VWW_GradientImageTableViewController*)sender
                       userSelectedNewImage:(UIImage*)image;
@end

@interface VWW_GradientImageTableViewController : UITableViewController
@property (nonatomic, assign) id <VWW_GradientImageTableViewDelegate> delegate;
@end
