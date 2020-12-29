//
//  CFoundPilotVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/4.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "CFoundPilotVC.h"
#import "CPaymentOptionVC.h"
#import <SVProgressHUD.h>
#import "UserModel.h"
#import "HttpApi.h"
#import "AppDelegate.h"

@interface CFoundPilotVC ()

@end

@implementation CFoundPilotVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getPilot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)getPilot{
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getPilotByBookId:g_myBook.bookId Completed:^(NSDictionary* result){
        [SVProgressHUD dismiss];
        UserModel *one = [[UserModel alloc] initWithDictionary:result];
        g_myBook.pilotId = one.userId;
        g_myBook.userInfo = one;
        if(one.firstName != nil && [one.firstName length] > 0){
            if(one.lastName == nil) one.lastName = @"";
            self.mTextLabel.text = [NSString stringWithFormat:@"%@ %@ have accepted your booking request.  To finalise booking please make payment.", one.firstName, one.lastName];
        } else{
            self.mTextLabel.text = [NSString stringWithFormat:@"%@ have accepted your booking request.  To finalise booking please make payment.", one.userName];
        }
        
    } Failed:^(NSString* errStr){
        [SVProgressHUD dismiss];
        g_myBook.pilotId =@"";
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

- (IBAction)onPayNowClick:(id)sender {
    CPaymentOptionVC* mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SID_CPaymentOptionVC"];
    [self.navigationController pushViewController:mVC animated:YES];
}
@end
