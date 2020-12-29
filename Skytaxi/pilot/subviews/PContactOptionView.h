//
//  PContactOptionView.h
//
//  Created by MeiLong Jing on 8/11/16.
//  Copyright © 2016 __CompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"

@class PContactOptionView;

@protocol PContactOptionViewDelegate <NSObject>

- (void)doneSaveWithContactOptionView:(PContactOptionView *)contactOptionView ChooseOption:(NSInteger)nChoose;

@end

@interface PContactOptionView : UIView

@property (strong, nonatomic) CustomIOSAlertView *m_alertView;
@property (nonatomic, strong) id <PContactOptionViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;

- (IBAction)onEmailClick:(id)sender;
- (IBAction)onCallClick:(id)sender;
- (IBAction)onCloseClick:(id)sender;

@end
