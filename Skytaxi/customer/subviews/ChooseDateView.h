//
//  ChooseDateView.h
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"

@class ChooseDateView;

@protocol ChooseDateViewDelegate <NSObject>

- (void)doneSaveWithChooseDateView:(ChooseDateView *)chooseDateView Option:(NSDate *)option;

@end

@interface ChooseDateView : UIView

@property (strong, nonatomic) CustomIOSAlertView *m_alertView;
@property (nonatomic, strong) id <ChooseDateViewDelegate> delegate;

@property (nonatomic) NSInteger type;
@property (nonatomic, strong) NSDate *mDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *mDatePicker;
- (IBAction)onSetClick:(id)sender;
- (IBAction)onCancelClick:(id)sender;

- (void)setLayout;
@end
