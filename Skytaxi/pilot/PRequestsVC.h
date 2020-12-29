//
//  PRequestsVC.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/6.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRequestsVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (nonatomic, strong) NSMutableArray *data;
- (IBAction)onBackClick:(id)sender;

@end
