//
//  VWW_ColorTableCell.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import "VWW_ColorTableCell.h"

@implementation VWW_ColorTableCell
@synthesize nameLabel = _nameLabel;
@synthesize hexLabel = _hexLabel;
@synthesize redLabel = _redLabel;
@synthesize greenLabel = _greenLabel;
@synthesize blueLabel = _blueLabel;
@synthesize hueLabel = _hueLabel;
@synthesize colorView = _colorView;


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

#pragma mark Custom methods


@end
