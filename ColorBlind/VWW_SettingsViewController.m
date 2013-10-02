//
//  VWW_SettingsViewController.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 10/1/13.
//
//

#import "VWW_SettingsViewController.h"

#define NSLocalizedString(key, comment) \
    [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]




@interface VWW_SettingsViewController ()
@property (retain, nonatomic) IBOutlet UILabel *settingsLabel;
@property (retain, nonatomic) IBOutlet UITextView *contentTextView;


@end

@implementation VWW_SettingsViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.settingsLabel.text = @"Settings";
    self.settingsLabel.text = [[NSBundle mainBundle] localizedStringForKey:@"a new one" value:@"" table:nil];
    

//    self.contentTextView.text = [[NSBundle mainBundle] localizedStringForKey:@"This is where settings text will go."; value:@"" table:nil];
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *numberString = [numberFormatter stringFromNumber:@(1000000)];
    self.contentTextView.text = [NSString stringWithFormat:NSLocalizedString(@"This is where settings text will go %@", nil), numberString];
}

- (void)dealloc {
    [_settingsLabel release];
    [_contentTextView release];
    [super dealloc];
}
@end
