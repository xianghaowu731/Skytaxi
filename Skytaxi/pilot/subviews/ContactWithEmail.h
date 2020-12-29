//
//  ContactWithEmail.h
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"

@class ContactWithEmail;

@protocol ContactWithEmailDelegate <NSObject>

- (void)doneSaveWithContactWithEmail:(ContactWithEmail *)contactView Content:(NSString *)content;

@end

@interface ContactWithEmail : UIView

@property (strong, nonatomic) CustomIOSAlertView *m_alertView;
@property (nonatomic, strong) id <ContactWithEmailDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextView *mTextView;
- (IBAction)onSendClick:(id)sender;
- (IBAction)onCancelClick:(id)sender;

@end
