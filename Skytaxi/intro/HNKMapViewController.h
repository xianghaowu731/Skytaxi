//
//  HNKMapViewController.h
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Tom OMalley on 8/11/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "UserModel.h"

@interface HNKMapViewController : UIViewController

@property (nonatomic, assign) CLLocationCoordinate2D m_CurCoordinate;
@property (nonatomic) UserModel *user;
@property (nonatomic) NSInteger mType;
- (IBAction)onBackClick:(id)sender;
- (IBAction)onUpdateAddr:(id)sender;

@end
