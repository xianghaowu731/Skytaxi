//
//  ChangeSetting.m
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import "ChangeSetting.h"
#import "Config.h"
#import "HttpApi.h"
#import <SVProgressHUD.h>

@interface ChangeSetting()
{
    
}

@end

@implementation ChangeSetting

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setLayout
{
    self.mUsername.text = self.data.userName;
    self.mEmail.text = self.data.email;
    self.mPhone.text = self.data.phone;
}

- (IBAction)onCloseClick:(id)sender {
    [self.m_alertView close];
}

- (IBAction)onUpdateClick:(id)sender {
    if(![self checkValidField]){
        return;
    }
    NSString *uname = self.mUsername.text;
    NSString *uemail = self.mEmail.text;
    NSString *uphone = self.mPhone.text;
    if([uname isEqualToString:self.data.userName] && [uemail isEqualToString:self.data.email] && [uphone isEqualToString:self.data.phone]){
        [self.m_alertView close];
    } else{
        [SVProgressHUD show];
        [[HttpApi sharedInstance] updateSetting:self.data.userId Username:uname Email:uemail Phone:uphone Completed:^(NSString *response) {
            [SVProgressHUD showSuccessWithStatus:@"Account Setting was updated successfully."];
            self.data.userName = uname;
            self.data.email = uemail;
            self.data.phone = uphone;
            [self doneSave];
        } Failed:^(NSString *errstr) {
            [SVProgressHUD showErrorWithStatus:errstr];
        }];
    }
}

- (BOOL)checkValidField{
    if([self.mUsername.text length] == 0){
        
        return false;
    }
    if([self.mEmail.text length] == 0){
        
        return false;
    }
    if([self.mPhone.text length] == 0){
        
        return false;
    }
    return true;
}

- (void)doneSave
{
    [self.delegate doneSaveWithChangeSetting:self];
    [self.m_alertView close];
}

@end
