//
//  VWW_ColorTableCellColorView.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/29/12.
//
//

#import "VWW_ColorTableCellColorView.h"

@implementation VWW_ColorTableCellColorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark UIView touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.delegate vww_ColorTableCellColorView:self userSelectedColor:self.backgroundColor];
}

/*
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
}
*/
@end
