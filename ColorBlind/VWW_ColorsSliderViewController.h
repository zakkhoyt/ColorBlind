//
//  VWW_ColorsSliderViewController.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import <UIKit/UIKit.h>
#import "VWW_Colors.h"
#import "VWW_ColorPickerView.h"
#import "VWW_ColorViewContoller.h"

@interface VWW_ColorsSliderViewController : UIViewController
    <VWW_ColorsDelegate,
    VWW_ColorPickerViewDelegate,
    VWW_ColorViewControllerDelegate>
@property (nonatomic, retain) VWW_Colors*           colors;
@end
