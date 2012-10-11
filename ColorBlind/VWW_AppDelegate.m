//
//  VWW_AppDelegate.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/18/12.
//

#import "VWW_AppDelegate.h"
#import "VWW_FileReader.h"
#import "VWW_AboutViewController.h"
#import "VWW_ColorsTableViewController.h"
#import "VWW_ColorsSliderViewController.h"
#import "VWW_ColorsPickerViewController.h"
#import "VWW_ColorsCameraViewController.h"
#import "VWW_WebService.h"

@interface VWW_AppDelegate ()
-(void)userDefaults;
@end

@implementation VWW_AppDelegate
@synthesize window = _window;
@synthesize colors = _colors;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    const NSUInteger kListTabIndex =    0;
    const NSUInteger kSliderTabIndex =  1;
    const NSUInteger kPickerTabIndex =  2;
    const NSUInteger kCameraTabIndex =  3;
    const NSUInteger kAboutTabIndex =   4;
    
//    // TODO: insert logic here to try the webservice/timeout/data decision
//    // First try to get colors from the webservice.
//    // If fails, then read colors from local file and then share the data with the controller classes
//    VWW_WebService* webService = [[VWW_WebService alloc]init];
//    [webService getNews];
    

    
    // Create our colors object and share it with all of the major view controllers.
    _colors = [[VWW_Colors alloc]init];
    
    [self userDefaults];
    
    // Share color array with all view controllers
    UITabBarController* tabBarController = (UITabBarController*)self.window.rootViewController;
    
    VWW_AboutViewController* aboutTabViewController = (VWW_AboutViewController*)[[tabBarController viewControllers]objectAtIndex:kAboutTabIndex];
    [aboutTabViewController setColors:_colors];
    
    VWW_ColorsTableViewController* colorsTableViewController = (VWW_ColorsTableViewController*)[[tabBarController viewControllers]objectAtIndex:kListTabIndex];
    [colorsTableViewController setColors:_colors];
    
    VWW_ColorsSliderViewController* colorsSliderViewController = (VWW_ColorsSliderViewController*)[[tabBarController viewControllers]objectAtIndex:kSliderTabIndex];
    [colorsSliderViewController setColors:_colors];
    
    VWW_ColorsPickerViewController* colorsPickerViewController = (VWW_ColorsPickerViewController*)[[tabBarController viewControllers]objectAtIndex:kPickerTabIndex];
    [colorsPickerViewController setColors:_colors];
    
    VWW_ColorsCameraViewController* colorsCameraViewController = (VWW_ColorsCameraViewController*)[[tabBarController viewControllers]objectAtIndex:kCameraTabIndex];
    [colorsCameraViewController setColors:_colors];
        
    // Set the current view controller to the About tab. This will show users instructions and news.
    [tabBarController setSelectedViewController:aboutTabViewController];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

#pragma mark Custom methods

-(void)userDefaults{
    // UserDefaults
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* currentColor = [defaults stringForKey:DEFAUTS_CURRENT_COLOR];

    if(!currentColor){
        if(_colors && _colors.count > 0){
            // Write the name of the first color
            [defaults setObject:[_colors colorAtIndex:0].name forKey:DEFAUTS_CURRENT_COLOR];
        }
    }
    else{
        // TODO: fill this in when we can get color by string
        // TODO: write this value when ever the current color is updated
    }
    
}

@end
