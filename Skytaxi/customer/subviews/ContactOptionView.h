//
//  ContactOptionView.h
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"

@class ContactOptionView;

@protocol ContactOptionViewDelegate <NSObject>

- (void)doneSaveWithContactOptionView:(ContactOptionView *)contactOptionView Option:(NSInteger)option;

@end

@interface ContactOptionView : UIView

@property (strong, nonatomic) CustomIOSAlertView *m_alertView;
@property (nonatomic, strong) id <ContactOptionViewDelegate> delegate;

- (IBAction)onEmailClick:(id)sender;
- (IBAction)onCallClick:(id)sender;
- (IBAction)onSocialClick:(id)sender;
- (IBAction)onCloseClick:(id)sender;

@end
