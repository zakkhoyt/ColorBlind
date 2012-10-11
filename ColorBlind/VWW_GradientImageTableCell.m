//
//  VWW_GradientImageTableCell.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/29/12.
//
//

#import "VWW_GradientImageTableCell.h"

@implementation VWW_GradientImageTableCell
@synthesize lblFileName;
@synthesize imagePreview;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [lblFileName release];
    [imagePreview release];
    [super dealloc];
}
@end
