//
//  ChooseReturnWay.m
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import "ChooseReturnWay.h"
#import "Config.h"

@interface ChooseReturnWay ()
{
    NSInteger nOption;
}

@end

@implementation ChooseReturnWay

- (void)awakeFromNib {
    [super awakeFromNib];
    nOption = 0;
    
}

- (void)doneSave
{
    [self.delegate doneSaveWithChooseReturnWay:self Option:nOption];
    [self.m_alertView close];
}

- (IBAction)onNoReturnClick:(id)sender {
    nOption = 0;
    [self doneSave];
}

- (IBAction)onSameDayClick:(id)sender {
    nOption = 1;
    [self doneSave];
}

- (IBAction)onDifferentDayClick:(id)sender {
    nOption = 2;
    [self doneSave];
}
@end
