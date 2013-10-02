//
//  VWW_ColorsTableViewController.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import "VWW_ColorsTableViewController.h"
#import "VWW_ColorTableCellColorView.h"
#import "VWW_ColorViewContoller.h"
#import "NSNumber+htmlValue.h"
#import "VWW_ColorTableCell.h"
#import "VWW_ColorViewContoller.h"


static const NSUInteger kNameTag = 100;
static const NSUInteger kHexTag = 101;
static const NSUInteger kRedTag = 102;
static const NSUInteger kGreenTag = 103;
static const NSUInteger kBlueTag = 104;
static const NSUInteger kHueTag = 105;

@interface VWW_ColorsTableViewController ()     <VWW_ColorsDelegate,
    VWW_ColorTableCellColorViewDelegate,
    VWW_ColorViewControllerDelegate>
@property (nonatomic, retain) NSMutableArray* data;
-(void)createDataSource;
-(void)loadLocalizedStrings;
-(void)receiveCurrentColorChangeNotification:(NSNotification*)notification;
-(void)receiveColorListChangeNotification:(NSNotification*)notification;
@end

@implementation VWW_ColorsTableViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    
    // Stop receiving notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createDataSource];
    
    [self loadLocalizedStrings];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCurrentColorChangeNotification:)
                                                 name:[NSString stringWithFormat:@"%s", NC_CURRENT_COLOR_CHANGED]
                                               object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // A segue is about to be performed. This is our chance to send data to the
    // view controller that will be loaded. 
	if ([segue.identifier isEqualToString:@"segue_VWW_ColorViewController"])
	{
		UINavigationController* navigationController = segue.destinationViewController;
		VWW_ColorViewContoller* colorViewController = [navigationController viewControllers][0];
        colorViewController.color = self.colors.currentColor;
		colorViewController.delegate = self;
	}
}

#pragma mark - Implements VWW_ColorProtocol

- (void) receiveCurrentColorChangeNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:[NSString stringWithFormat:@"%s", NC_CURRENT_COLOR_CHANGED]]){
        NSDictionary *userInfo = notification.userInfo;
        VWW_Color* currentColor = userInfo[@"currentColor"];
        NSLog (@"%s:%d Received notification. New current color is %@. ", __FUNCTION__, __LINE__, currentColor.name);
    }
}
-(void)receiveColorListChangeNotification:(NSNotification*)notification{
    if ([[notification name] isEqualToString:[NSString stringWithFormat:@"%s", NC_COLOR_LIST_CHANGED]])
        NSLog (@"%s:%d Received notification for color list", __FUNCTION__, __LINE__);
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the VWW_Color object from our data source and then
    // pass it to our colors object to notify all other controllers
    // of the current color.
    NSMutableDictionary* d = (NSMutableDictionary*)(self.data)[indexPath.section];
    NSArray* a = d[@"colors"];
    VWW_Color* color = a[indexPath.row];
    [self.colors setCurrentColor:color];
    
    [self performSegueWithIdentifier:@"segue_VWW_ColorViewController" sender:self];
}

#pragma mark - Table view data source


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!self.data){
        // TODO; raise error?
    }
    NSMutableDictionary* d = (NSMutableDictionary*)(self.data)[section];
    if(!d){
        // TODO; raise error?
    }
    NSArray* a = d[@"colors"];
    if(!a){
        // TODO; raise error?
    }
    return a.count;
    
}

// Asking how to populate the tableview cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // We are using a custom table cell. See VWW_ColorTableCell.h
    VWW_ColorTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VWW_ColorTableCell"];
    NSMutableDictionary* d = (NSMutableDictionary*)(self.data)[indexPath.section];
    NSArray* a = d[@"colors"];
    VWW_Color* color = a[indexPath.row];
    
    // Safety check
    if(!color){
        return cell;
    }
    
    cell.nameLabel.text = color.name;
    cell.hexLabel.text = [NSString stringWithFormat:@"#%@", color.hex];
    cell.redLabel.text = [NSString stringWithFormat:@"r:%d", color.red.integerValue];
    cell.greenLabel.text = [NSString stringWithFormat:@"g:%d", color.green.integerValue];
    cell.blueLabel.text = [NSString stringWithFormat:@"b:%d", color.blue.integerValue];
    cell.colorView.backgroundColor = color.color;
    
    // Set the cell's delegate to self.
    cell.colorView.delegate = self;

    return cell;
    
}


// This method is asking for the letters to use in the scrubber for the tableview
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray* array = [[[NSMutableArray alloc]init]autorelease];
    for(NSUInteger index = 0; index < self.data.count; index++){
        NSDictionary* dict = (self.data)[index];
        NSString* headerTitle = [dict valueForKey:@"headerTitle"];
        [array addObject:headerTitle];
    }
    return array;
}

//#pragma mark Implements VWW_ColorTableCellDelegate
//// This is callback from our color view within a table cell.
//// Open the color for full screen display
//
//-(void)userSelectedColor:(UIColor*)color{
//    if(![self.colors setCurrentColorFromUIColor:color]){
//        NSLog(@"%s:%d ERROR! Failed to set current color from UIColor", __FUNCTION__, __LINE__);
//    }
//    
//    [self performSegueWithIdentifier:@"segue_VWW_ColorViewController" sender:self];
//}

#pragma mark Implements VWW_ColorTableCellColorViewDelegate
-(void)vww_ColorTableCellColorView:(VWW_ColorTableCellColorView*)sender userSelectedColor:(UIColor*)color{
    if(![self.colors setCurrentColorFromUIColor:color]){
        NSLog(@"%s:%d ERROR! Failed to set current color from UIColor", __FUNCTION__, __LINE__);
    }

    [self performSegueWithIdentifier:@"segue_VWW_ColorViewController" sender:self];
}

#pragma mark Implements  VWW_ColorViewControllerDelegate
-(void)vww_ColorViewContollerUerIsDone:(VWW_ColorViewContoller*)sender{
    [sender dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Custom methods

// We already have an NSMutableArray of VWW_Color objects sorted by color.name.
// We need to take that array and make a new array of NSMutableDictionary entries for the indexed table view
// Each NSMutableDictionary contains two entries;
// "colors" is an NSMutableArray of VWW_Color objects (each beginning with the same letter)
// "headerTitle" is an NSString that contains a single letter for the quick index scrubber
-(void)createDataSource{
    
    const NSUInteger kMaxColorsArraySize = 26; // maximum 26 letters in the alphabet
    self.data = [[NSMutableArray alloc]initWithCapacity:kMaxColorsArraySize];
    
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyz";
    for (NSUInteger index = 0; index < letters.length; index++ ) {
        NSMutableDictionary* dict = [[[NSMutableDictionary alloc]init]autorelease];
        NSMutableArray* array = [[[NSMutableArray alloc]init]autorelease];
        
        char cl[2] = { toupper([letters characterAtIndex:index]), '\0'};
        NSString* currentLetter = [NSString stringWithFormat:@"%s", cl];
        for(NSUInteger colorsIndex = 0; colorsIndex < self.colors.count; colorsIndex++){
            VWW_Color* color = [self.colors colorAtIndex:colorsIndex];
            if([color.name hasPrefix:currentLetter] == YES){
                [array addObject:color];
            }
        }
        [dict setValue:currentLetter forKey:@"headerTitle"];
        [dict setValue:array forKey:@"colors"];
        [self.data addObject:dict];
    }
}


-(void)loadLocalizedStrings{
    
}

@end
