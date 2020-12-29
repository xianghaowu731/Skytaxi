//
//  CustomMainVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/1.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "CustomMainVC.h"
#import "CProfileVC.h"
#import "CTripsVC.h"
#import "CSettingsVC.h"
#import "HelpVController.h"
#import "TermsVController.h"
#import "FaqVController.h"
#import "BookFlightVC.h"
#import "AppDelegate.h"
#import "AirportModel.h"
#import "UserModel.h"
#import "Common.h"
#import <SVProgressHUD.h>
#import "HttpApi.h"
#import "Config.h"
#import "CFindPilotVC.h"
#import "BookModel.h"
#import "CFoundPilotVC.h"

extern UserModel *customer;

@interface CustomMainVC ()

@end

@implementation CustomMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBookAccept:) name:NOTIFICATION_BOOK_ACCEPT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBookCancel:) name:NOTIFICATION_BOOK_CANCEL object:nil];
    self.navigationController.navigationBar.hidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    [self loadData];
    [self checkStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)changeBookAccept:(NSNotification*)msg{
    [[HttpApi sharedInstance] getBookByStatus:customer.userId StatusID:BOOK_ACCEPTED Completed:^(NSMutableDictionary *result){
        g_myBook = [[BookModel alloc] initWithDictionary:result];
        [self removeLocalNotification];
        CFoundPilotVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CFoundPilotVC"];
        [self.navigationController pushViewController:mVC animated:YES];
    } Failed:^(NSString *err){
    }];
}

- (void) checkStatus{
    [[HttpApi sharedInstance] getBookByStatus:customer.userId StatusID:BOOK_WAITING Completed:^(NSMutableDictionary *result){
        g_myBook = [[BookModel alloc] initWithDictionary:result];
        g_waitingStatus = 2;
        CFindPilotVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CFindPilotVC"];
        [self.navigationController pushViewController:mVC animated:YES];
    } Failed:^(NSString *err){
        [[HttpApi sharedInstance] getBookByStatus:customer.userId StatusID:BOOK_ACCEPTED Completed:^(NSMutableDictionary *result){
            g_myBook = [[BookModel alloc] initWithDictionary:result];
            [self removeLocalNotification];
            CFoundPilotVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CFoundPilotVC"];
            [self.navigationController pushViewController:mVC animated:YES];
        } Failed:^(NSString *err){
        }];
    }];
}

- (void)changeBookCancel:(NSNotification*)msg{
    NSString *bookId = msg.userInfo[@"book_id"];
    NSString *alertstr = msg.userInfo[@"alert"];
    NSString *title = [NSString stringWithFormat:@"Cancelled Book Book ID:%@", bookId];
    [self showAlertDlg:title Msg:alertstr];
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
                                    //Handel your yes please button action here
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}

- (void)removeLocalNotification{
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        if ([localNotification.alertTitle isEqualToString:@"Booking Not Confirmed"]) {
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

- (IBAction)onProfileClick:(id)sender {
    CProfileVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CProfileVC"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onBookFlightClick:(id)sender {
    BookFlightVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_BookFlightVC"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onMyTripsClick:(id)sender {
    CTripsVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CTripsVC"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onSettingClick:(id)sender {
    CSettingsVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CSettingsVC"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onHelpClick:(id)sender {
    HelpVController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_HelpVController"];
    mVC.data = customer;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onLogoutClick:(id)sender {
    [[HttpApi sharedInstance] logout:customer.userId Completed:^(NSString* result){
        
    } Failed:^(NSString *errstr){
        
    }];
    [Common saveValueKey:@"remember_login" Value:@"0"];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* mVC = [sb instantiateViewControllerWithIdentifier:@"SID_SignNC"];
    [self presentViewController:mVC animated:YES completion:NULL];
}

- (IBAction)onTermsClick:(id)sender {
    TermsVController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_TermsVController"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onQuestionClick:(id)sender {
    FaqVController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_FaqVController"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (NSDictionary *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"airport" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (void)loadData{
    g_airportArray = [[NSMutableArray alloc] init];
    NSDictionary *dict = [self JSONFromFile];    
    NSArray *baseArray = [dict objectForKey:@"data"];
    for (NSDictionary *oneBase in baseArray) {
        AirportModel *one = [[AirportModel alloc] initWithDictionary:oneBase];
        [g_airportArray addObject:one];
    }
}
@end
