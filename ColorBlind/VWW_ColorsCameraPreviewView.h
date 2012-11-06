//
//  VWW_ColorsCameraPreviewView.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/27/12.
//
//

#import <UIKit/UIKit.h>
#import "VWW_Colors.h"

@class VWW_ColorsCameraPreviewView;

@protocol VWW_ColorCameraPreviewViewDelegate <NSObject>
-(void)vww_ColorsCameraPreviewView:(VWW_ColorsCameraPreviewView*)sender userSelectedPixel:(CGPoint)pixel withColor:(VWW_Color*)color;
@end

@interface VWW_ColorsCameraPreviewView : UIView 
@property (nonatomic, retain) VWW_Colors* colors;
@property (nonatomic, assign) id <VWW_ColorCameraPreviewViewDelegate> delegate;
@end
