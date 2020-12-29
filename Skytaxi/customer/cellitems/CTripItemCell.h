//
//  CTripItemCell.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/18.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@interface CTripItemCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mArrivalLabel;
@property (weak, nonatomic) IBOutlet UILabel *mBookIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTripNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mBookDateLabel;
@property (nonatomic) BOOL bSelect;
@end
