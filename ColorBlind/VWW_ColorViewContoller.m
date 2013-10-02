//
//  VWW_ColorViewContoller.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/23/12.
//
//

#import "VWW_ColorViewContoller.h"

@interface VWW_ColorViewContoller ()

-(void)loadLocalizedStrings;
- (IBAction)handle_btnDone:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblColorName;
@property (retain, nonatomic) IBOutlet UILabel *lblColorDetails;
@property (retain, nonatomic) IBOutlet UILabel *lblRed;
@property (retain, nonatomic) IBOutlet UILabel *lblGreen;
@property (retain, nonatomic) IBOutlet UILabel *lblBlue;

@end

@implementation VWW_ColorViewContoller
@synthesize lblColorName = _lblColorName;
@synthesize lblColorDetails = _lblColorDetails;
@synthesize color = _color;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = self.color.color;
    self.lblColorName.text = self.color.name;
    self.lblColorDetails.text = self.color.hex;
    self.lblRed.text = [NSString stringWithFormat:@"Red: %d", self.color.red.integerValue];
    self.lblGreen.text = [NSString stringWithFormat:@"Green: %d", self.color.green.integerValue];
    self.lblBlue.text = [NSString stringWithFormat:@"Blue: %d", self.color.blue.integerValue];
    [self loadLocalizedStrings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark Custom methods
-(void)loadLocalizedStrings{
    
}

- (IBAction)handle_btnDone:(id)sender {
    [self.delegate vww_ColorViewContollerUerIsDone:self];
}

- (void)dealloc {
    [_lblColorName release];
    [_lblColorDetails release];
    [_lblRed release];
    [_lblGreen release];
    [_lblBlue release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblColorName:nil];
    [self setLblColorDetails:nil];
    [super viewDidUnload];
}
@end
