//
//  ContactWithEmail.m
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import "ContactWithEmail.h"
#import "Config.h"

@interface ContactWithEmail ()
{
    
}

@end

@implementation ContactWithEmail

- (void)awakeFromNib {
    [super awakeFromNib];
    CALayer *imageLayer = self.mTextView.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:PRIMARY_COLOR.CGColor];
}

- (void)doneSave
{    
    [self.delegate doneSaveWithContactWithEmail:self Content:self.mTextView.text ];
    [self.m_alertView close];
}


- (IBAction)onSendClick:(id)sender {
    [self doneSave];
}

- (IBAction)onCancelClick:(id)sender {
    self.mTextView.text = @"";
    [self doneSave];
}
@end
