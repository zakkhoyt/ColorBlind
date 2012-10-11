//
//  VWW_ColorsTableViewController.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import <UIKit/UIKit.h>
#import "VWW_Colors.h"
#import "VWW_ColorTableCellColorView.h"
#import "VWW_ColorViewContoller.h"

@interface VWW_ColorsTableViewController : UITableViewController
    <VWW_ColorsDelegate, VWW_ColorTableCellColorViewDelegate, VWW_ColorViewControllerDelegate>
@property (nonatomic, retain) VWW_Colors* colors;
@end
