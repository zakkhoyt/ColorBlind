//
//  VWW_ColorsCameraViewController.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/27/12.
//
//

#import <AVFoundation/AVFoundation.h>
#import "VWW_Color.h"
#import "VWW_ColorsCameraViewController.h"
#import "VWW_ColorPickerView.h"
#import "VWW_ColorsCameraPreviewView.h"
#import "VWW_ColorPickerImageViewCrosshairsView.h"
#import "VWW_ColorsCameraPreviewView.h"

@interface VWW_ColorsCameraViewController () <VWW_ColorsDelegate,
    VWW_ColorCameraPreviewViewDelegate,
    AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, retain) IBOutlet VWW_ColorsCameraPreviewView* cameraPreview;
@property (retain, nonatomic) IBOutlet UILabel *lblColorName;
@property (retain, nonatomic) IBOutlet UILabel *lblColorDetails;
@property (retain, nonatomic) IBOutlet VWW_ColorPickerView *currentColorView;
@property (retain, nonatomic) IBOutlet VWW_ColorPickerImageViewCrosshairsView* crosshairsView;
@property (retain, nonatomic) NSTimer* crosshairViewTimer;
@property (retain, nonatomic) IBOutlet UIButton *btnCamera;
@property dispatch_queue_t av_queue;// = dispatch_queue_create("com.vaporwarewolf.colorblind", NULL);
-(void)drawCrosshairs;
-(void)loadLocalizedStrings;
-(void)startCamera;
- (IBAction)handle_btnCamera:(id)sender;
@end

@implementation VWW_ColorsCameraViewController
@synthesize lblColorName = _lblColorName;
@synthesize lblColorDetails = _lblColorDetails;
@synthesize currentColorView = _currentColorView;
@synthesize colors = _colors;
@synthesize cameraPreview = _cameraPreview;
@synthesize crosshairViewTimer = _crosshairViewTimer;
@synthesize btnCamera = _btnCamera;




-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.av_queue = dispatch_queue_create("com.vaporwarewolf.colorblind", NULL);
    }
    return self;
}

-(void)dealloc{
    // Stop receiving notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_lblColorName release];
    [_lblColorDetails release];
    [_currentColorView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadLocalizedStrings];
    
    // Share our data with child controls
    self.cameraPreview.colors = self.colors;
    self.cameraPreview.delegate = self;
    
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
    dispatch_async(self.av_queue, ^{
        [self startCamera];
    });
}

- (void)viewDidUnload {
    [self.crosshairViewTimer invalidate];
    self.crosshairViewTimer = nil;
    
    [self setLblColorName:nil];
    [self setLblColorDetails:nil];
    [self setCurrentColorView:nil];
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

#pragma mark - Implements VWW_ColorCameraPreviewViewDelegate
-(void)vww_ColorsCameraPreviewView:(VWW_ColorsCameraPreviewView*)sender userSelectedPixel:(CGPoint)pixel withColor:(VWW_Color*)color{
    
}

#pragma mark implements AVFoundation

// For image resizing, see the following links:
// http://stackoverflow.com/questions/4712329/how-to-resize-the-image-programatically-in-objective-c-in-iphone
// http://stackoverflow.com/questions/6052188/high-quality-scaling-of-uiimage

-(void)captureOutput :(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection{
    
    
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    

    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    
    // Let's grab the center pixel
    NSUInteger halfWidth = floor(width/2.0);
    NSUInteger halfHeight = floor(height/2.0);

    
    NSArray* pixels = [self getRGBAsFromImage:image atX:halfWidth andY:halfHeight count:1];

    UIColor* uicolor = [pixels objectAtIndex:0];
    CGFloat red, green, blue, alpha = 0;
    [uicolor getRed:&red green:&green blue:&blue alpha:&alpha];
//    NSLog(@"r=%f g=%f b=%f a=%f", red, green, blue, alpha);


    VWW_Color* color = [self.colors colorFromRed:[NSNumber numberWithInt:red*100]
                                           Green:[NSNumber numberWithInt:green*100]
                                            Blue:[NSNumber numberWithInt:blue*100]];
    

    static bool hasRunOnce = NO;
    if(!hasRunOnce){
        hasRunOnce = YES;
        NSLog(@"Camera is outputting frames at %dx%d", (int)width, (int)height);
        NSLog(@"We will be examinign pixel in row %d column %d", (int)(halfWidth * height), (int)halfHeight);
    }
  
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.lblColorName.text = color.name;
        self.lblColorDetails.text = color.description;
        self.currentColorView.backgroundColor = color.color;
        self.crosshairsView.selectedPixel = CGPointMake(halfWidth, halfHeight);
    });
}

#pragma mark Custom methods			

-(void)drawCrosshairs{
    [self.crosshairsView setNeedsDisplay];
}

-(void)loadLocalizedStrings{
    
}

-(void)startCamera{
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // Set the captures resolution. This varies from device to device

    //          iPad43      iPhone4
    // * low    192x144     192x144
    // * medium 480x360     480x360
    // * hight  1920x1080   1280x720
    // * photo  2048x1536   852x640
    
//    session.sessionPreset = AVCaptureSessionPresetLow;
    session.sessionPreset = AVCaptureSessionPresetMedium;
//    session.sessionPreset = AVCaptureSessionPresetHigh;
//	session.sessionPreset = AVCaptureSessionPresetPhoto;

	CALayer *viewLayer = self.cameraPreview.layer;
	NSLog(@"viewLayer = %@", viewLayer);

	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];

	captureVideoPreviewLayer.frame = self.cameraPreview.bounds;
	[self.cameraPreview.layer addSublayer:captureVideoPreviewLayer];

	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!input) {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[session addInput:input];
    
    // ************************* configure AVCaptureSession to deliver raw frames via callback (as well as preview layer)
    AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    NSMutableDictionary * cameraVideoSettings = [[[NSMutableDictionary alloc] init] autorelease];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]; //kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange];
    [cameraVideoSettings setValue:value forKey:key];
    [videoOutput setVideoSettings:cameraVideoSettings];
    [videoOutput setAlwaysDiscardsLateVideoFrames:YES];

//    [videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    [videoOutput setSampleBufferDelegate:self queue:self.av_queue];
    
    
    if([session canAddOutput:videoOutput]){
        [session addOutput:videoOutput];
    }
    else {
        NSLog(@"Could not add videoOutput");
    }
    
	[session startRunning];

}

- (IBAction)handle_btnCamera:(id)sender {
    
}



#pragma mark Image stuff....

- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ++ii)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    
    return result;
}


@end

