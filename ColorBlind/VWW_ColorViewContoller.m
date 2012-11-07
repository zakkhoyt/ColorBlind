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
    self.lblColorDetails.text = self.color.description;
    
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
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblColorName:nil];
    [self setLblColorDetails:nil];
    [super viewDidUnload];
}
@end
