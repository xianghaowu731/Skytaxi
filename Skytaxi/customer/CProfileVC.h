//
//  CProfileVC.h
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/2.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CProfileVC : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mMapView;
@property (weak, nonatomic) IBOutlet UIImageView *mUserImgView;
@property (weak, nonatomic) IBOutlet UILabel *mAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTotalTimeMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTotalFlightBooked;

@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionView;

- (IBAction)onBackClick:(id)sender;

@end
