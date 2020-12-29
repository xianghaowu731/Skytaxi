//
//  PilotMainVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/5.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "PilotMainVC.h"
#import "PProfileVC.h"
#import "AppDelegate.h"
#import "AirportModel.h"
#import "PSettingsVC.h"
#import "HelpVController.h"
#import "TermsVController.h"
#import "FaqVController.h"
#import "PRequestsVC.h"
#import "PAcceptedFlightVC.h"
#import "Common.h"
#import "UserModel.h"
#import "HttpApi.h"
#import <SVProgressHUD.h>
#import "Config.h"

extern UserModel *pilot;

@interface PilotMainVC (){
    NSMutableArray *requestData;
}

@end

@implementation PilotMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBookWait:) name:NOTIFICATION_BOOK_WAIT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBookCancel:) name:NOTIFICATION_BOOK_CANCEL object:nil];
    
    requestData = [[NSMutableArray alloc] init];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNewRequests];
}

- (void)changeBookWait:(NSNotification*)msg{
    PRequestsVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_PRequestsVC"];
    mVC.data = requestData;
    [self.navigationController pushViewController:mVC animated:YES];
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

- (void)loadNewRequests{
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getNewRequest:^(NSArray* result){
        [SVProgressHUD dismiss];
        requestData = [[NSMutableArray alloc] initWithArray:result];
        if(requestData.count > 0){
            PRequestsVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_PRequestsVC"];
            mVC.data = requestData;
            [self.navigationController pushViewController:mVC animated:YES];
        }
    } Failed:^(NSString *errstr){
        [SVProgressHUD dismiss];
    }];
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
    PProfileVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_PProfileVC"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onNewRequestsClick:(id)sender {
    PRequestsVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_PRequestsVC"];
    mVC.data = requestData;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onConfirmedRequestsClick:(id)sender {
    PAcceptedFlightVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_PAcceptedFlightVC"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onSettingClick:(id)sender {
    PSettingsVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_PSettingsVC"];
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onHelpClick:(id)sender {
    HelpVController* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_HelpVController"];
    mVC.data = pilot;
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)onLogoutClick:(id)sender {
    [[HttpApi sharedInstance] logout:pilot.userId Completed:^(NSString* result){
        
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

- (IBAction)onQuestionsClick:(id)sender {
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
