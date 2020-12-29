//
//  AppDelegate.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/3/31.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "AppDelegate.h"
#import "Config.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteQuery.h>
#import <OneSignal/OneSignal.h>
#import "Common.h"
#import <PayPalMobile.h>


@interface AppDelegate ()

@end

AppDelegate *g_appDelegate;
NSInteger g_nChoose;
NSMutableArray* g_airportArray;
NSInteger g_loginType;
NSInteger g_waitingStatus;
BookModel *g_myBook;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    g_appDelegate = self;
    [HNKGooglePlacesAutocompleteQuery setupSharedQueryWithAPIKey:GOOGLE_API_KEY];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //google sign in
    [GIDSignIn sharedInstance].clientID = GOOGLE_YOUR_CLIENT_ID;
    //facebook signin
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    //Notification setting
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    // One Signal
    
    // (Optional) - Create block the will fire when a notification is recieved while the app is in focus.
    id notificationRecievedBlock = ^(OSNotification *notification) {
        OSNotificationPayload* payload = notification.payload;
        NSString *noti_id = payload.additionalData[@"notification_id"];
        NSString *alert_str = payload.additionalData[@"alert"];
        
        if([noti_id isEqualToString:BOOK_ACCEPTED] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BOOK_ACCEPT object:self userInfo:nil];
        } else if([noti_id isEqualToString:BOOK_DECLINE]){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BOOK_DECLINE object:self userInfo:nil];
        } else if([noti_id isEqualToString:BOOK_WAITING] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BOOK_WAIT object:self userInfo:nil];
        } else if([noti_id isEqualToString:BOOK_PAID] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BOOK_PAID object:self userInfo:nil];
        } else if([noti_id isEqualToString:BOOK_CANCELLED] ){
            NSString *bookId = payload.additionalData[@"book_id"];
            NSDictionary *info = @{@"id":noti_id, @"alert":alert_str, @"book_id":bookId};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BOOK_CANCEL object:self userInfo:info];
        } else if([noti_id isEqualToString:BOOK_DELETE] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_OUT object:self userInfo:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BOOK_STATUS object:self userInfo:nil];
        }
        
        [AppDelegate increaseUnreadNotificationsCount:payload.additionalData];
    };
    
    // (Optional) - Create block that will fire when a notification is tapped on.
    id notificationOpenedBlock = ^(OSNotificationOpenedResult *result) {
        OSNotificationPayload* payload = result.notification.payload;
        
        NSString *noti_id = payload.additionalData[@"notification_id"];
        NSString *alert_str = payload.additionalData[@"alert"];
        
        if([noti_id isEqualToString:BOOK_ACCEPTED] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BOOK_ACCEPT object:self userInfo:nil];
        } else if([noti_id isEqualToString:BOOK_DECLINE]){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BOOK_DECLINE object:self userInfo:nil];
        } else if([noti_id isEqualToString:BOOK_WAITING] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BOOK_WAIT object:self userInfo:nil];
        } else if([noti_id isEqualToString:BOOK_PAID] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BOOK_PAID object:self userInfo:nil];
        } else if([noti_id isEqualToString:BOOK_CANCELLED] ){
            NSString *bookId = payload.additionalData[@"book_id"];
            NSDictionary *info = @{@"id":noti_id, @"alert":alert_str, @"book_id":bookId};
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BOOK_CANCEL object:self userInfo:info];
        } else if([noti_id isEqualToString:BOOK_DELETE] ){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_OUT object:self userInfo:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BOOK_STATUS object:self userInfo:nil];
        }
        
    };
    
    // (Optional) - Configuration options for OneSignal settings.
    id oneSignalSetting = @{kOSSettingsKeyInFocusDisplayOption : @(OSNotificationDisplayTypeNotification), kOSSettingsKeyAutoPrompt : @YES};
    
    // (REQUIRED) - Initializes OneSignal
    [OneSignal initWithLaunchOptions:launchOptions
                               appId:ONESIGNAL_APP_ID
          handleNotificationReceived:notificationRecievedBlock
            handleNotificationAction:notificationOpenedBlock
                            settings:oneSignalSetting];
    
    [OneSignal IdsAvailable:^(NSString* userId, NSString* pushToken) {
        if (pushToken) {
            //NSLog(@"UserId-  %@, pushToken-  %@", userId, pushToken);
            [Common saveValueKey:@"token" Value:userId];
        } else {
            //self.textMultiLine1.text = @"ERROR: Could not get a pushToken from Apple! Make sure your provisioning profile has 'Push Notifications' enabled and rebuild your app.";
            NSLog(@"\n%@", @"ERROR: Could not get a pushToken from Apple! Make sure your provisioning profile has 'Push Notifications' enabled and rebuild your app.");
        }
    }];
    
    //user local notification
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!error) {
                                  //NSLog(@"request authorization succeeded!");                                  
                              }
                          }];

    
//#warning "Enter your credentials"
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : PAYPAL_ID_FOR_PRODUCTION,
                                                           PayPalEnvironmentSandbox : PAYPAL_ID_FOR_SANDBOX}];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
    
    NSString* urlStr = url.absoluteString;
    NSString* preChar = @"";
    for(int i=0;i<2;i++) {
        char character = [urlStr characterAtIndex:i];
        preChar = [NSString stringWithFormat:@"%@%c", preChar, character];
    }
    if([preChar isEqualToString:@"fb"]) {
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:app
                                                                      openURL:url
                                                            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                                   annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                        ];
        return handled;
    } else {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSString* urlStr = url.absoluteString;
    NSString* preChar = @"";
    for(int i=0;i<2;i++) {
        char character = [urlStr characterAtIndex:i];
        preChar = [NSString stringWithFormat:@"%@%c", preChar, character];
    }
    if([preChar isEqualToString:@"fb"]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    } else {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
        
    }
}
    
//================================================
//Register For notifications
//================================================


// RemoteNotification
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}
    
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif
    
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // NSLog(@"Error %@",error.localizedDescription);
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *badgenumber=[NSString stringWithFormat:@"%@",userInfo[@"aps"][@"badge"]];
    [self.notificationDelegate updateNotificationDetails:badgenumber];
    //[[Common simpleAlert:@"Notification" desc:userInfo[@"aps"][@"alert"]] show];
    NSLog(@"Push received: %@", userInfo);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
   
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ENTER_BACKGROUND object:self userInfo:nil];    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ENTER_FOREGROUND object:self userInfo:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
    [[GIDSignIn sharedInstance] signOut];
}

+ (void)increaseUnreadNotificationsCount:(NSDictionary *)userInfo
{
    if(g_appDelegate.unreadNotificationsCount == nil)
        return;
    g_appDelegate.unreadNotificationsCount = [NSString stringWithFormat:@"%ld", [g_appDelegate.unreadNotificationsCount integerValue] + 1];
    [UIApplication sharedApplication].applicationIconBadgeNumber = [g_appDelegate.unreadNotificationsCount integerValue];
    //[[Common simpleAlert:@"Notification" desc:userInfo[@"alert"]] show];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BOOK_STATUS object:self userInfo:nil];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSString *noti_id = notification.userInfo[@"notification_id"];
    
    if([noti_id isEqualToString:BOOK_DELETE] ){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_OUT object:self userInfo:nil];
    }
}

@end
