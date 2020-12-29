//
//  ChangeSetting.h
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
#import "UserModel.h"

@class ChangeSetting;

@protocol ChangeSettingDelegate <NSObject>

- (void)doneSaveWithChangeSetting:(ChangeSetting *)changeSetting;

@end

@interface ChangeSetting : UIView

@property (strong, nonatomic) CustomIOSAlertView *m_alertView;
@property (nonatomic, strong) id <ChangeSettingDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *mUsername;
@property (weak, nonatomic) IBOutlet UITextField *mPhone;
@property (weak, nonatomic) IBOutlet UITextField *mEmail;

@property (strong, nonatomic) UserModel* data;

- (IBAction)onCloseClick:(id)sender;
- (IBAction)onUpdateClick:(id)sender;

-(void)setLayout;

@end
