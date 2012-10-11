//
//  VWW_ColorTableCell.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import <UIKit/UIKit.h>
#import "VWW_ColorTableCellColorView.h"

@interface VWW_ColorTableCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel* nameLabel;
@property (nonatomic, retain) IBOutlet UILabel* hexLabel;
@property (nonatomic, retain) IBOutlet UILabel* redLabel;
@property (nonatomic, retain) IBOutlet UILabel* greenLabel;
@property (nonatomic, retain) IBOutlet UILabel* blueLabel;
@property (nonatomic, retain) IBOutlet UILabel* hueLabel;
@property (nonatomic, retain) IBOutlet VWW_ColorTableCellColorView*  colorView;
@end
