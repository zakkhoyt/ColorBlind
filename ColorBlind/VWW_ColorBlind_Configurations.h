//
//  VWW_ColorBlind_Configurations.h
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/19/12.
//
//

#ifndef ColorBlind_VWW_ColorBlind_Configurations_h
#define ColorBlind_VWW_ColorBlind_Configurations_h

// TODO: Explore the use of const NSString* vs #define
// Example: const NSString* kWebServerHTTPPostBody = @"app_id=com.vaporwarewolf.colorblind&get_news=1";


#define DEFAUTS_CURRENT_COLOR @"currentColor"

#define USE_GCD 1                       // This will use Grand Centrl Dispath to communicate to the webserver and not block the main UI

// TODO: Maybe remove this since we are always going to use NC
//#define USE_NOTIFICATION_CENTER 1       // Use notification center to contact delegates

#define WS_HTTP_POST_BODY_NEWS "app_id=com.vaporwarewolf.colorblind&get_news=1"
#define WS_HTTP_POST_BODY_COLORS "app_id=com.vaporwarewolf.colorblind&get_colors=1"
#define WS_SERVER_ADDRESS "http://zakkhoyt.kicks-ass.net/ColorBlind/index.php"
#define NC_CURRENT_COLOR_CHANGED "com.vaporwarewolf.colorblind.currentcolor"
#define NC_COLOR_LIST_CHANGED "com.vaporwarewolf.colorblind.colorlist"
#endif
