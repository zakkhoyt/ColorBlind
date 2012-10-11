//
//  VWW_ColorsPickerViewController.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//
//

#import <UIKit/UIKit.h>
#import "VWW_Colors.h"
#import "VWW_ColorPickerImageView.h"
#import "VWW_GradientImageTableViewController.h"
#import "VWW_ColorViewContoller.h"
#import "VWW_ColorPickerView.h"


@interface VWW_ColorsPickerViewController : UIViewController
    <VWW_ColorsDelegate,
    VWW_ColorPickerImageViewDelegate,
    VWW_GradientImageTableViewDelegate,
    VWW_ColorViewControllerDelegate,
    VWW_ColorPickerViewDelegate>
@property (nonatomic, retain) VWW_Colors* colors;
@end
