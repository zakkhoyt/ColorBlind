//
//  VWW_ColorsCameraViewController.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/27/12.
//
//

#import "VWW_ColorsCameraViewController.h"
#import "VWW_ColorPickerView.h"
#import "VWW_ColorsCameraPreviewView.h"
#import "VWW_ColorPickerImageViewCrosshairsView.h"

@interface VWW_ColorsCameraViewController ()
@property (nonatomic, retain) IBOutlet VWW_ColorsCameraPreviewView* cameraPreview;
@property (retain, nonatomic) IBOutlet UILabel *lblColorName;
@property (retain, nonatomic) IBOutlet UILabel *lblColorDetails;
@property (retain, nonatomic) IBOutlet VWW_ColorPickerView *currentColorView;
@property (retain, nonatomic) IBOutlet VWW_ColorPickerImageViewCrosshairsView* crosshairsView;
@property (retain, nonatomic) NSTimer* crosshairViewTimer;
@property (retain, nonatomic) IBOutlet UIButton *btnCamera;
-(void)drawCrosshairs;
-(void)loadLocalizedStrings;
-(void)startCamera;
- (IBAction)handle_btnCamera:(id)sender;

// Image stuff
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
@end

@implementation VWW_ColorsCameraViewController
@synthesize lblColorName = _lblColorName;
@synthesize lblColorDetails = _lblColorDetails;
@synthesize currentColorView = _currentColorView;
@synthesize colors = _colors;
@synthesize cameraPreview = _cameraPreview;
@synthesize crosshairViewTimer = _crosshairViewTimer;
@synthesize btnCamera = _btnCamera;

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
    
    [self startCamera];
    
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

#pragma mark implements AVFoundation

// For image resizing, see the following links:
// http://stackoverflow.com/questions/4712329/how-to-resize-the-image-programatically-in-objective-c-in-iphone
// http://stackoverflow.com/questions/6052188/high-quality-scaling-of-uiimage

-(void)captureOutput :(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection{

    // Check if it is safe to access the frame. This is probably not necessary now adays
    if(!CMSampleBufferDataIsReady(sampleBuffer)){
        NSLog( @"sample buffer is not ready. Skipping sample" );
        return;
    }

    // Access each frame as raw data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
//    void *src_buff = CVPixelBufferGetBaseAddress(imageBuffer);

    static bool hasRunOnce = NO;
    if(!hasRunOnce){
        NSLog(@"Camera is returning video frames with size %dx%d", (int)width, (int)height);
        hasRunOnce = YES;
    }
    
    
    
//    - (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size
    
        
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}

#pragma mark Custom methods			

-(void)drawCrosshairs{
    [self.crosshairsView setNeedsDisplay];
}

-(void)loadLocalizedStrings{
    
}

-(void)startCamera{
//    AVCaptureSession *session = [[AVCaptureSession alloc] init];
//	session.sessionPreset = AVCaptureSessionPresetMedium;
//    
//	CALayer *viewLayer = self.cameraPreview.layer;
//	NSLog(@"viewLayer = %@", viewLayer);
//    
//	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
//    
//	captureVideoPreviewLayer.frame = self.cameraPreview.bounds;
//	[self.cameraPreview.layer addSublayer:captureVideoPreviewLayer];
//    
//	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    
//	NSError *error = nil;
//	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
//	if (!input) {
//		// Handle the error appropriately.
//		NSLog(@"ERROR: trying to open camera: %@", error);
//	}
//	[session addInput:input];
//    
//	[session startRunning];
    
    
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // Set the captures resolution. This varies from device to device

    
    
    //          iPad43      iPhone4
    // * low    192x144     192x144
    // * medium 480x360     480x360
    // * hight  1920x1080   1280x720
    // * photo  2048x1536   852x640
    
//    session.sessionPreset = AVCaptureSessionPresetLow;
//    session.sessionPreset = AVCaptureSessionPresetMedium;
//    session.sessionPreset = AVCaptureSessionPresetHigh;
	session.sessionPreset = AVCaptureSessionPresetPhoto;

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
    // TODO: Are we going to need yet another queue? Test on an old slow device to see
    //dispatch_queue_t queue = dispatch_queue_create("cameraQueue", NULL);
    [videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    //  dispatch_release(queue);
    if([session canAddOutput:videoOutput]){
        [session addOutput:videoOutput];
    }
    else {
        NSLog(@"Could not add videoOutput");
    }
    // ************************* configure callback for frame by frame access ********************
    
//    CGRect frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//    [self.cameraPreview setFrame:frame];
    
	[session startRunning];
    
    


}

- (IBAction)handle_btnCamera:(id)sender {
    
}





#pragma mark Image stuff....
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

@end

