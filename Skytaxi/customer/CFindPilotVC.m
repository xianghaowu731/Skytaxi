//
//  CFindPilotVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/4.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "CFindPilotVC.h"
#import "Config.h"
#import "CFoundPilotVC.h"
#import "HttpApi.h"
#import "AppDelegate.h"
#import "Common.h"
#import "NetworkManager.h"

@interface CFindPilotVC (){
    NSInteger timecount;
    //NSTimer *myTimer;
    NSInteger endCount;
}

@end

@implementation CFindPilotVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBookAccept:) name:NOTIFICATION_BOOK_ACCEPT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBookDecline:) name:NOTIFICATION_BOOK_DECLINE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeViewLayout:) name:NOTIFICATION_ENTER_FOREGROUND object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeoutProcess:) name:NOTIFICATION_TIME_OUT object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(terminateApp:) name:NOTIFICATION_ENTER_BACKGROUND object:nil];
    
    [self setLayout];
    CALayer *imgLayer = self.mIndicatorView.layer;
    [self rotateLayerInfinite:imgLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setLayout{
    timecount = 0;
    if(g_waitingStatus == 1){
        endCount = TIMER_MAX_COUNT;
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:(endCount - 1)*TIMER_INTERVAL];
        notification.alertTitle = @"Booking Not Confirmed";
        notification.alertBody = @"No pilot are available for your flight. Try request a new date and time as pilot may be available then.";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = 1;
        notification.userInfo = @{@"notification_id":@"7"};
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        g_waitingStatus = 2;
        
    } else{
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"yyyy-MMM-dd h:mm a"];
        NSDate* bookDate = [outputFormatter dateFromString:g_myBook.bookTime];
        NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:bookDate];
        endCount = secondsBetween / TIMER_INTERVAL;
    }
    
    if(endCount < 0 || endCount > TIMER_MAX_COUNT){
        CALayer *imgLayer = self.mIndicatorView.layer;
        [imgLayer removeAllAnimations];
        [self removeLocalNotification];
        [[HttpApi sharedInstance] deleteRequestBook:g_myBook.bookId
                                          Completed:^(NSString *result){
                                              if([result isEqualToString:@"1"]){
                                                  CFoundPilotVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CFoundPilotVC"];
                                                  [self.navigationController pushViewController:mVC animated:YES];
                                              } else{
                                                  UIAlertController * alert=   [UIAlertController
                                                                                alertControllerWithTitle:@"Booking Not Confirmed"
                                                                                message:@"No pilot are available for your flight. Try request a new date and time as pilot may be available then."
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                                  UIAlertAction* yesButton = [UIAlertAction
                                                                              actionWithTitle:@"Ok"
                                                                              style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action)
                                                                              {
                                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                                              }];
                                                  [alert addAction:yesButton];
                                                  [self presentViewController:alert animated:YES completion:nil];
                                              }
                                          } Failed:^(NSString *errstr){
                                              [self showAlertDlg:@"Warning" Msg:@"The Booking is too close to flight. Please contact Skytaxi support."];
                                          }];
    }
}

- (void)changeBookAccept:(NSNotification*)msg{
    //if(myTimer != nil){
    //    [myTimer invalidate];
    //    myTimer = nil;
    //}
    //CFoundPilotVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CFoundPilotVC"];
    //[self.navigationController pushViewController:mVC animated:YES];
}

- (void)activeViewLayout:(NSNotification*)msg{
    CALayer *imgLayer = self.mIndicatorView.layer;
    [self rotateLayerInfinite:imgLayer];
}

- (void)changeBookDecline:(NSNotification*)msg{
    CALayer *imgLayer = self.mIndicatorView.layer;
    [imgLayer removeAllAnimations];
    [self removeLocalNotification];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)timeoutProcess:(NSNotification*)msg{
    CALayer *imgLayer = self.mIndicatorView.layer;
    [imgLayer removeAllAnimations];
    [self removeLocalNotification];
    [[HttpApi sharedInstance] deleteRequestBook:g_myBook.bookId
                                      Completed:^(NSString *result){
                                          if([result isEqualToString:@"1"]){
                                              CFoundPilotVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CFoundPilotVC"];
                                              [self.navigationController pushViewController:mVC animated:YES];
                                          } else{
                                              UIAlertController * alert=   [UIAlertController
                                                                            alertControllerWithTitle:@"Booking Not Confirmed"
                                                                            message:@"No pilot are available for your flight. Try request a new date and time as pilot may be available then."
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                              UIAlertAction* yesButton = [UIAlertAction
                                                                          actionWithTitle:@"Ok"
                                                                          style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action)
                                                                          {
                                                                              [self.navigationController popViewControllerAnimated:YES];
                                                                          }];
                                              [alert addAction:yesButton];
                                              [self presentViewController:alert animated:YES completion:nil];
                                          }
                                      } Failed:^(NSString *errstr){
                                          [self showAlertDlg:@"Warning" Msg:@"The Booking is too close to flight. Please contact Skytaxi support."];
                                          
                                      }];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)rotateLayerInfinite:(CALayer *)layer
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    rotation.duration = 1.0f; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [layer removeAllAnimations];
    [layer addAnimation:rotation forKey:@"Spin"];
}

- (void)removeLocalNotification{
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        if ([localNotification.alertTitle isEqualToString:@"Booking Not Confirmed"]) {
            //NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onButtonClick:(id)sender {
    
}

- (IBAction)onCancelClick:(id)sender {
    if(![NetworkManager IsConnectionAvailable]){
        [self showAlertDlg:@"Network Error" Msg:@"Please check network status."];
        return;
    }
    CALayer *imgLayer = self.mIndicatorView.layer;
    [imgLayer removeAllAnimations];
    [self removeLocalNotification];
    
    [[HttpApi sharedInstance] deleteRequestBook:g_myBook.bookId
                                      Completed:^(NSString *result){
                                          if([result isEqualToString:@"1"]){
                                              CFoundPilotVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CFoundPilotVC"];
                                              [self.navigationController pushViewController:mVC animated:YES];
                                          } else{
                                              [self.navigationController popViewControllerAnimated:YES];
                                          }
                                      } Failed:^(NSString *errstr){
                                          [self showAlertDlg:@"Warning" Msg:@"The Booking is too close to flight. Please contact Skytaxi support."];
                                      }];
}

- (void)showAlertDlg:(NSString*) title Msg:(NSString*)msg{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}
@end
