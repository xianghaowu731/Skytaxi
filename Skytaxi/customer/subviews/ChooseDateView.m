//
//  ChooseDateView.m
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import "ChooseDateView.h"
#import "Config.h"

@interface ChooseDateView ()
{
    NSDate *nOption;
}

@end

@implementation ChooseDateView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setLayout{
    if(self.type == 0)//Date
    {
        [self.mDatePicker setDatePickerMode:UIDatePickerModeDate];
    } else{
        [self.mDatePicker setDatePickerMode:UIDatePickerModeTime];
        [self.mDatePicker setMinuteInterval:30];
    }
    [self.mDatePicker setDate:self.mDate];
    nOption = self.mDate;
}

- (void)doneSave
{
    [self.delegate doneSaveWithChooseDateView:self Option:nOption];
    [self.m_alertView close];
}

- (IBAction)onSetClick:(id)sender {
    nOption = self.mDatePicker.date;
    [self doneSave];
}

- (IBAction)onCancelClick:(id)sender {
    [self.m_alertView close];
}
@end
