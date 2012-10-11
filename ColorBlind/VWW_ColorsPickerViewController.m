//
//  VWW_ColorsPickerViewController.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//
//

#import "VWW_ColorsPickerViewController.h"
#import "VWW_ColorPickerView.h"
#import "VWW_ColorPickerImageViewCrosshairsView.h"



@interface VWW_ColorsPickerViewController ()
@property (nonatomic, retain) IBOutlet VWW_ColorPickerImageView* colorPickerImageView;
@property (retain, nonatomic) IBOutlet UILabel *lblColorName;
@property (retain, nonatomic) IBOutlet UILabel *lblColorDetails;
@property (retain, nonatomic) IBOutlet VWW_ColorPickerView *currentColorView;
@property (retain, nonatomic) IBOutlet VWW_ColorPickerImageViewCrosshairsView* crosshairsView;
@property (retain, nonatomic) NSTimer* crosshairViewTimer;
@property (retain, nonatomic) IBOutlet UIButton *butLoadImage;
- (IBAction)handle_butLoadImage:(id)sender;

-(void)drawCrosshairs;
-(void)loadLocalizedStrings;
@end

@implementation VWW_ColorsPickerViewController
@synthesize lblColorName = _lblColorName;
@synthesize lblColorDetails = _lblColorDetails;
@synthesize currentColorView = _currentColorView;
@synthesize colors = _colors;
@synthesize colorPickerImageView = _colorPickerImageView;
@synthesize crosshairViewTimer = _crosshairViewTimer;
@synthesize butLoadImage = _butLoadImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void)dealloc{
    // Stop receiving notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_lblColorName release];
    [_lblColorDetails release];
    [_currentColorView release];
    [_butLoadImage release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadLocalizedStrings];
    
    // Share our data with child controls
    self.colorPickerImageView.colors = self.colors;
    self.colorPickerImageView.delegate = self;
    
    // Listen for touch events
    self.currentColorView.delegate = self;

    // Register to get updates when any other controller changes colors.currentColor
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCurrentColorChangeNotification:)
                                                 name:[NSString stringWithFormat:@"%s", NC_CURRENT_COLOR_CHANGED]
                                               object:nil];
    
    // Add a timer to call [crosshairView setNeedsDisplay] until we find a better solution
    self.crosshairViewTimer = [NSTimer scheduledTimerWithTimeInterval:1/30.0
                                     target:self
                                   selector:@selector(drawCrosshairs)
                                   userInfo:nil
                                    repeats:YES];

}

- (void)viewDidUnload {
    [self.crosshairViewTimer invalidate];
    self.crosshairViewTimer = nil;
    
    [self setLblColorName:nil];
    [self setLblColorDetails:nil];
    [self setCurrentColorView:nil];
    [self setButLoadImage:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // A segue is about to be performed. This is our chance to send data to the
    // view controller that will be loaded.
	if ([segue.identifier isEqualToString:@"segue_VWW_ColorViewController"])
	{
		UINavigationController* navigationController = segue.destinationViewController;
		VWW_ColorViewContoller* colorViewController = [[navigationController viewControllers]objectAtIndex:0];
        colorViewController.color = self.colors.currentColor;
		colorViewController.delegate = self;
	}
}


#pragma mark - Implements VWW_ColorDelegate

- (void) receiveCurrentColorChangeNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:[NSString stringWithFormat:@"%s", NC_CURRENT_COLOR_CHANGED]]){
        NSDictionary *userInfo = notification.userInfo;
        VWW_Color* currentColor = [userInfo objectForKey:@"currentColor"];
        NSLog (@"%s:%d Received notification. New current color is %@. ", __FUNCTION__, __LINE__, currentColor.name);
    }
}
-(void)receiveColorListChangeNotification:(NSNotification*)notification{
    if ([[notification name] isEqualToString:[NSString stringWithFormat:@"%s", NC_COLOR_LIST_CHANGED]])
        NSLog (@"%s:%d Received notification for color list", __FUNCTION__, __LINE__);
}


#pragma mark - Implements VWW_ColorPickerImageViewDelegate

-(void)userSelectedPixel:(CGPoint)pixel withColor:(VWW_Color*)color{
    // Tell the crosshair view where to draw
    if(self.crosshairsView){
        [self.crosshairsView setSelectedPixel:pixel];
//        [self.crosshairsView setNeedsDisplay];
    }

    if(color){
        self.lblColorName.text = color.name;
        self.lblColorDetails.text = color.description;
        self.currentColorView.backgroundColor = color.color;
    }
    
}

-(void)userDoubleTapped{
    // Our user double tapped the color gradient picture. Let's perform our segue to show a table of more gradient files.
    [self performSegueWithIdentifier:@"segue_VWW_GradientImageTableViewController" sender:self];
}

#pragma mark - Implements VWW_ColorPickerViewDelegate
// This is callback from our color view within a table cell.
// Open the color for full screen display
-(void)userSelectedColor:(UIColor*)color{
    if(![self.colors setCurrentColorFromUIColor:color]){
        NSLog(@"%s:%d ERROR! Failed to set current color from UIColor", __FUNCTION__, __LINE__);
    }
    
    [self performSegueWithIdentifier:@"segue_VWW_ColorViewController" sender:self];
}


#pragma mark - Implements VWW_ColorViewControllerDelegate
-(void)userIsDone{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Implements VWW_GradientImageTableViewDelegate
-(void)userSelectedNewImage:(UIImage*)image{
    
}

#pragma mark Custom methods			

- (IBAction)handle_butLoadImage:(id)sender {
}

-(void)drawCrosshairs{
    [self.crosshairsView setNeedsDisplay];
}

-(void)loadLocalizedStrings{
// TODO: fix bug. These strings aren't loading correctly
//    // Load default labels from local string file
//    NSString* localString = NSLocalizedStringFromTable (@"VWW_ColorPickerViewController.lblColorName.text", @"custom", @"");
//    self.lblColorName.text = localString;
//    
//    localString = NSLocalizedStringFromTable (@"VWW_ColorPickerViewController.lblColorDetails.text", @"custom", @"");
//    self.lblColorDetails.text = localString;
}


@end











