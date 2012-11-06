//
//  VWW_WebService.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/19/12.
//
//


#import "VWW_WebService.h"

@interface VWW_WebService (){
    dispatch_queue_t _webServiceQueue;
}
// Use a different connection for each query subject
@property (nonatomic, retain) NSURLConnection* newsConnection;
@property (nonatomic, retain) NSURLConnection* colorsConnection;

// This method is run on a secondary queue using GCD. The potential size of the
// response is very large. Enough to block the UI for sure.
// It then calls it's VWW_WebServiceColorsDelegate
-(void)processColors:(NSString*)colors;

// This method is run on a secondary queue using GCD. The potential size of the
// response is very large. Enough to block the UI for sure.
// It then calls it's VWW_WebServiceNewsDelegate
-(void)processNews:(NSString*)news;

@end


@implementation VWW_WebService
@synthesize newsConnection = _newsConnection;
-(id)init{
    self = [super init];
    if(self){
        _webServiceQueue = dispatch_queue_create("com.vaporwarewolf", NULL);
    }
    return self;
}

- (void)dealloc {
    dispatch_release(_webServiceQueue);
    [super dealloc];
}


#pragma mark Implements NSURLConnectionDelegate protocol

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%s", __FUNCTION__);
    
    // cast the response to NSHTTPURLResponse so we can look for 404 etc
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger code = [httpResponse statusCode];
    
    // Since processing these results can take a while, use GCD so that we dont' block the  main UI
    switch(code){
        case 200:
            break;
        case 404:
            if(connection == self.newsConnection){
                // TODO: hanle error. Tell delegate?
            }
            else{
                // TODO: hanle error. Tell delegate?
            }
            break;
        default:
            NSLog(@"remote url returned error %d %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)mdata {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", [NSString stringWithFormat:@"%s",(char*)[mdata bytes]]);
    
    
    NSString* dataString = [NSString stringWithFormat:@"%s",(char*)[mdata bytes]];
    
    
    // Compare the NSURLConnection so we know what we are receiving a response to 
    if(connection == self.newsConnection){
        // Since processing these results can take a while depending on file size, use GCD so that we dont' block the  main UI
#if defined(USE_GCD)
        dispatch_async(_webServiceQueue, ^{
            [self processNews:dataString];
        });
#else
        [self processNews:dataString];
#endif
        // We are done with our connection
        [self.newsConnection release];
        self.newsConnection = nil;
    }
    else if(connection == self.colorsConnection){
        // Since processing these results can take a while depending on file size, use GCD so that we dont' block the  main UI
#if defined(USE_GCD)
        dispatch_async(_webServiceQueue, ^{
            [self processColors:dataString];
        });
#else
        [self processColors:dataString];
#endif
        // We are done with our connection
        [self.colorsConnection release];
        self.colorsConnection = nil;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%s", __FUNCTION__);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%s ERROR (%@)", __FUNCTION__, error.description);
}



#pragma mark Custom methods

// TODO: minor: Possibly refactor getColors and getNews to use a common method
-(void)getColors{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%s", WS_SERVER_ADDRESS]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    // Set request timeout.
    [request setTimeoutInterval:60.0];
    
    // Set http method to POST
    [request setHTTPMethod:@"POST"];
    
    // Set http body
    NSString* body = [NSString stringWithFormat:@"%s", WS_HTTP_POST_BODY_COLORS];
    NSData *requestData = [NSData dataWithBytes:[body UTF8String]length:[body length]];
    [request setHTTPBody:requestData];
    
    // Creat connection and test for results. This will kick off our callbacks from NSURLConnectionDelegate protocol
    self.colorsConnection = [[NSURLConnection alloc]initWithRequest:request
                                                         delegate:self
                                                 startImmediately:YES];
    
    if(!self.colorsConnection) {
 		NSLog(@"Failed to create NSURLConnection to retreieve current colors set");
 	}
    
    [request release];

}
// TODO: minor: Possibly refactor getColors and getNews to use a common method
-(void)getNews{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%s", WS_SERVER_ADDRESS]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    // Set request timeout
    [request setTimeoutInterval:10.0];
    
    // Set http method to POST
    [request setHTTPMethod:@"POST"];
    
    // Set http body
    NSString* body = [NSString stringWithFormat:@"%s", WS_HTTP_POST_BODY_NEWS];
    NSData *requestData = [NSData dataWithBytes:[body UTF8String]length:[body length]];
    [request setHTTPBody:requestData];
    
    // Creat connection and test for results. This will kick off our callbacks from NSURLConnectionDelegate protocol
    self.newsConnection = [[NSURLConnection alloc]initWithRequest:request
                                                                 delegate:self
                                                         startImmediately:YES];
    
    if(!self.newsConnection) {
        NSLog(@"Failed to create NSURLConnection to retreieve news");
 	}
    
    [request release];
}


-(void)processColors:(NSString*)colors{
    // Do any heavy processing here. In this case we expect to recieve the data in good working format.
    
    // Send the information to our delegate
    if(self.colorsDelegate){
        // Since this is being processed on a secondary queue and we are trying to update the UI
        // we need to send this block to the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.colorsDelegate vww_WebService:self recievedColors:colors];
        });
    }
}


-(void)processNews:(NSString*)news{
    // Do any heavy processing here. In this case we are not doing any processing,
    // but if we do in the future, we won't be blocking the UI.
    
    // Send the information to our delegate
    if(self.newsDelegate){
        // Since this is being processed on a secondary queue and we are trying to update the UI
        // we need to send this block to the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.newsDelegate vww_WebService:self recievedNews:news];
        });
    }
}


@end
