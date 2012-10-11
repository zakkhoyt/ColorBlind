//
//  VWW_AboutViewController.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/19/12.
//
//  

#import <UIKit/UIKit.h>
#import "VWW_WebService.h"
#import "VWW_Colors.h"


@interface VWW_AboutViewController : UIViewController <VWW_WebServiceNewsDelegate>
@property (nonatomic, retain) VWW_Colors* colors;
@end
