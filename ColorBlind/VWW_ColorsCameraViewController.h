//
//  VWW_ColorsCameraViewController.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/27/12.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VWW_Colors.h"
#import "VWW_ColorsCameraPreviewView.h"

@interface VWW_ColorsCameraViewController : UIViewController <VWW_ColorsDelegate, VWW_ColorCameraPreviewViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, retain) VWW_Colors* colors;
@end
