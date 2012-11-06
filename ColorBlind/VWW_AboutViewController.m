//
//  VWW_AboutViewController.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/19/12.
//
//

#import "VWW_AboutViewController.h"
#import "VWW_FileReader.h"
#import "VWW_WebService.h"

@interface VWW_AboutViewController ()  <VWW_WebServiceNewsDelegate>
@property (retain, nonatomic) IBOutlet UITextView *lblAbout;
@property (retain, nonatomic) IBOutlet UITextView *lblAppTitle;
@property (retain, nonatomic) IBOutlet UITextView *lblNews;
@property (retain, nonatomic) IBOutlet UIWebView *lblWebView;
-(void)loadLocalizedStrings;
@end

@implementation VWW_AboutViewController
@synthesize colors = _colors;
@synthesize lblAbout = _lblAbout;
@synthesize lblAppTitle = _lblAppTitle;
@synthesize lblNews = _lblNews;
@synthesize lblWebView = _lblWebView;


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

    [self loadLocalizedStrings];
    
    VWW_WebService* webService = [[VWW_WebService alloc]init];
    webService.newsDelegate = self;
    [webService getNews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.lblAbout release];
    [self.lblAppTitle release];
    [self.lblNews release];
    [self.lblWebView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblAbout:nil];
    [self setLblAppTitle:nil];
    [self setLblNews:nil];
    [self setLblWebView:nil];
    [super viewDidUnload];
}

#pragma mark Custom methods

-(void)loadLocalizedStrings{
    // Load default labels from local string file
    NSString* localString = NSLocalizedStringFromTable (@"VWW_AboutViewController.lblAppTitle.text", @"custom", @"");
    self.lblAppTitle.text = localString;
    
    localString = NSLocalizedStringFromTable (@"VWW_AboutViewController.lblAbout.text", @"custom", @"");
    self.lblAbout.text = localString;
    
    localString = NSLocalizedStringFromTable (@"VWW_AboutViewController.lblNews.text", @"custom", @"");
    self.lblNews.text = localString;
}

#pragma mark Implements VWW_WebServiceNewsDelegate
-(void)vww_WebService:(VWW_WebService*)sender recievedNews:(NSString*)news{
    self.lblNews.text = news;
}




@end
