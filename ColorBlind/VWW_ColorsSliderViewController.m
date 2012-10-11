//
//  VWW_ColorsSliderViewController.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import "VWW_ColorsSliderViewController.h"

@interface VWW_ColorsSliderViewController ()
@property (retain, nonatomic) IBOutlet UISlider*    sliderRed;
@property (retain, nonatomic) IBOutlet UISlider*    sliderGreen;
@property (retain, nonatomic) IBOutlet UISlider*    sliderBlue;
@property (retain, nonatomic) IBOutlet VWW_ColorPickerView*      colorView;
@property (retain, nonatomic) IBOutlet UILabel*     colorName;
@property (retain, nonatomic) IBOutlet UILabel*     colorDetails;
@property NSUInteger                                currentRed;
@property NSUInteger                                currentGreen;
@property NSUInteger                                currentBlue;

-(void)loadLocalizedStrings;
-(void)updateDisplay:(VWW_Color*)closestColor;
- (IBAction)handle_sliderRed:(id)sender;
- (IBAction)handle_sliderGreen:(id)sender;
- (IBAction)handle_sliderBlue:(id)sender;
@end

@implementation VWW_ColorsSliderViewController
@synthesize colors = _colors;
@synthesize sliderRed = _sliderRed;
@synthesize sliderGreen = _sliderGreen;
@synthesize sliderBlue = _sliderBlue;
@synthesize colorView = _colorView;
@synthesize colorName = _colorName;
@synthesize colorDetails = _colorDetails;
@synthesize currentRed = _currentRed;
@synthesize currentGreen = _currentGreen;
@synthesize currentBlue = _currentBlue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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



#pragma mark - Implements VWW_ColorProtocol

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

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadLocalizedStrings];
    
    // Retrieve the current color and set our UI and ivars to reflect it
    [self updateDisplay:self.colors.currentColor];
    self.currentRed = self.colors.currentColor.red.integerValue;
    self.currentGreen = self.colors.currentColor.green.integerValue;
    self.currentBlue = self.colors.currentColor.blue.integerValue;
    self.sliderRed.value = self.currentRed/100.0f;
    self.sliderGreen.value = self.currentGreen/100.0f;
    self.sliderBlue.value = self.currentBlue/100.0f;
    
    // Register for touch events
    self.colorView.delegate = self;
    
    // Register to get updates when any other controller changes colors.currentColor
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCurrentColorChangeNotification:)
                                                 name:[NSString stringWithFormat:@"%s", NC_CURRENT_COLOR_CHANGED]
                                               object:nil];
        
}


- (void)viewDidUnload
{
    [self setSliderRed:nil];
    [self setSliderGreen:nil];
    [self setSliderBlue:nil];
    [self setColorView:nil];
    [self setColorName:nil];
    [self setColorDetails:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    // Stop receiving notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_sliderRed release];
    [_sliderGreen release];
    [_sliderBlue release];
    [_colorView release];
    [_colorName release];
    [_colorDetails release];
    [super dealloc];
}

#pragma mark Custom methods

-(void)loadLocalizedStrings{
    
}

-(void)updateDisplay:(VWW_Color*)currentColor{
    self.colorView.backgroundColor = currentColor.color;
    self.colorName.text = currentColor.name;
    self.colorDetails.text = currentColor.description;
}


- (IBAction)handle_sliderRed:(id)sender {
    UISlider* slider = (UISlider*)sender;
    self.currentRed = slider.value * 100;
    VWW_Color* closestColor = [self.colors colorFromRed:[NSNumber numberWithInteger:self.currentRed]
                                                  Green:[NSNumber numberWithInteger:self.currentGreen]
                                                   Blue:[NSNumber numberWithInteger:self.currentBlue]];
    
    [self.colors setCurrentColor:closestColor];
    [self updateDisplay:closestColor];
}

- (IBAction)handle_sliderGreen:(id)sender {
    UISlider* slider = (UISlider*)sender;
    self.currentGreen = slider.value * 100;
    VWW_Color* closestColor = [self.colors colorFromRed:[NSNumber numberWithInteger:self.currentRed]
                                                  Green:[NSNumber numberWithInteger:self.currentGreen]
                                                   Blue:[NSNumber numberWithInteger:self.currentBlue]];
    [self.colors setCurrentColor:closestColor];
    [self updateDisplay:closestColor];
}

- (IBAction)handle_sliderBlue:(id)sender {
    UISlider* slider = (UISlider*)sender;
    self.currentBlue = slider.value * 100;
    VWW_Color* closestColor = [self.colors colorFromRed:[NSNumber numberWithInteger:self.currentRed]
                                                  Green:[NSNumber numberWithInteger:self.currentGreen]
                                                   Blue:[NSNumber numberWithInteger:self.currentBlue]];
    [self.colors setCurrentColor:closestColor];
    [self updateDisplay:closestColor];
}
@end
