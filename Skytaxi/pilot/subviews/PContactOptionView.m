//
//  PContactOptionView.m
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import "PContactOptionView.h"
#import "Config.h"

@interface PContactOptionView ()
{
    NSInteger nChoose;
}

@end

@implementation PContactOptionView

- (void)awakeFromNib {
    [super awakeFromNib];
    nChoose = 0;
}

- (void)doneSave
{    
    [self.delegate doneSaveWithContactOptionView:self ChooseOption:nChoose];
    [self.m_alertView close];
}

- (IBAction)onEmailClick:(id)sender {
    nChoose = 1;//Email
    [self doneSave];
}

- (IBAction)onCallClick:(id)sender {
    nChoose = 2;//Contact
    [self doneSave];
}

- (IBAction)onCloseClick:(id)sender {
    [self.m_alertView close];
}

@end
