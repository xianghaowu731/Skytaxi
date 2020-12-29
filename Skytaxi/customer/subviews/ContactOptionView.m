//
//  ContactOptionView.m
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import "ContactOptionView.h"
#import "Config.h"

@interface ContactOptionView ()
{
    NSInteger nOption;
}

@end

@implementation ContactOptionView

- (void)awakeFromNib {
    [super awakeFromNib];
    nOption = 0;
    
}

- (void)doneSave
{
    [self.delegate doneSaveWithContactOptionView:self Option:nOption];
    [self.m_alertView close];
}

- (IBAction)onEmailClick:(id)sender {
    nOption = 1;
    [self doneSave];
}

- (IBAction)onCallClick:(id)sender {
    nOption = 2;
    [self doneSave];
}

- (IBAction)onSocialClick:(id)sender {
    nOption = 3;
    [self doneSave];
}

- (IBAction)onCloseClick:(id)sender {
    [self.m_alertView close];
}
@end
