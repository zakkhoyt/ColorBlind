//
//  VWW_WebService.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/19/12.
//
//

#import <Foundation/Foundation.h>

@class VWW_WebService;

@protocol VWW_WebServiceNewsDelegate <NSObject>
-(void)vww_WebService:(VWW_WebService*)sender recievedNews:(NSString*)news;
@end

@protocol VWW_WebServiceColorsDelegate <NSObject>
-(void)vww_WebService:(VWW_WebService*)sender recievedColors:(NSString*)colors;
@end



@interface VWW_WebService : NSObject <NSURLConnectionDelegate>
@property (nonatomic, assign) id <VWW_WebServiceNewsDelegate> newsDelegate;
@property (nonatomic, assign) id <VWW_WebServiceColorsDelegate> colorsDelegate;
-(void)getColors;
-(void)getNews;
@end
