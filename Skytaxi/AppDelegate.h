//
//  AppDelegate.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/3/31.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"
@import GoogleSignIn;
@import UserNotifications;

@class AppDelegate;

extern AppDelegate *g_appDelegate;
extern NSInteger g_nChoose;
extern NSMutableArray* g_airportArray;
extern NSInteger g_loginType;
extern NSInteger g_waitingStatus;
extern BookModel *g_myBook;

@protocol updateNotifications <NSObject>
    
-(void)updateNotificationDetails:(NSString *)badgeNumber;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
    
@property (strong,nonatomic) id<updateNotifications> notificationDelegate;
    
@property (strong, nonatomic) NSString *unreadNotificationsCount;
@property (strong, nonatomic) NSString *unreadNotificationId;


@end

