//
//  HelpVController.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/2.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "UserModel.h"

@interface HelpVController : UIViewController<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *mMessageTxt;

@property (strong, nonatomic) UserModel* data;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onFaqClick:(id)sender;
- (IBAction)onAboutClick:(id)sender;
- (IBAction)onSendClick:(id)sender;

@end
