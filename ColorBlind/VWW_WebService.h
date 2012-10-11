//
//  VWW_WebService.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/19/12.
//
//

#import <Foundation/Foundation.h>
@protocol VWW_WebServiceNewsDelegate <NSObject>
-(void)recievedNews:(NSString*)news;
@end

@protocol VWW_WebServiceColorsDelegate <NSObject>
-(void)recievedColors:(NSString*)colors;
@end



@interface VWW_WebService : NSObject <NSURLConnectionDelegate>
@property (nonatomic, assign) id <VWW_WebServiceNewsDelegate> newsDelegate;
@property (nonatomic, assign) id <VWW_WebServiceColorsDelegate> colorsDelegate;
-(void)getColors;
-(void)getNews;
@end
