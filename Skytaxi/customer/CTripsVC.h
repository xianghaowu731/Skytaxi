//
//  CTripsVC.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/2.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTripsVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mFilterLabel;
@property (weak, nonatomic) IBOutlet UILabel *mSortLabel;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

- (IBAction)onSettingClick:(id)sender;
- (IBAction)onBackClick:(id)sender;
@end
