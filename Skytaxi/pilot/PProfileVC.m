//
//  PProfileVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/6.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "PProfileVC.h"
#import "CProfileBookedItem.h"
#import "Config.h"
#import "ZSAnnotation.h"
#import "UserModel.h"
#import <LMGeocoder.h>
#import "AppDelegate.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import "HttpApi.h"

extern UserModel *pilot;

@interface PProfileVC ()<UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate,CLLocationManagerDelegate>{
    
    CLLocationManager *m_locationManager;
    CLLocationCoordinate2D mHomeCoordinate;
    NSMutableArray* mAnnotationArray;
}
@property(nonatomic, strong) NSMutableArray* bookedArray;
@property(nonatomic, strong) NSString *tf_time;
@property(nonatomic, strong) NSString *book_count;
@end

@implementation PProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBookWait:) name:NOTIFICATION_BOOK_WAIT object:nil];
    
    self.bookedArray = [[NSMutableArray alloc] init];
    self.tf_time = @"0";
    self.book_count = @"0";
    CALayer *imageLayer = self.mUserImgView.layer;
    [imageLayer setCornerRadius:42];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setBorderColor:CONTROLL_EDGE_COLOR.CGColor];
    
    // Start getting current location
    m_locationManager = [[CLLocationManager alloc] init];
    m_locationManager.delegate = self;
    m_locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    m_locationManager.distanceFilter = kCLDistanceFilterNone;//100;
    if([m_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [m_locationManager requestWhenInUseAuthorization];
    }
    [m_locationManager startUpdatingLocation];
    
    mAnnotationArray = [[NSMutableArray alloc] init];
    
    if(g_loginType == LOGIN_TYPE_SOCIAL){
        [self.mUserImgView sd_setImageWithURL:[NSURL URLWithString:pilot.photo]];
    } else{
        NSString* filename = pilot.photo;
        if([filename length] == 0) filename = @"default.png";
        NSString* url = [NSString stringWithFormat:@"%@%@%@", SERVER_URL, USER_PHOTO_BASE_URL, filename];
        [self.mUserImgView sd_setImageWithURL:[NSURL URLWithString:url]];
    }
    
    [self loadData];
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)changeBookWait:(NSNotification*)msg{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setLayout{
    self.mUserNameLabel.text =[NSString stringWithFormat:@"%@ %@",pilot.userName, pilot.lastName];
    
    self.mTotalTimeMinLabel.text = self.tf_time;
    self.mTotalFlightBooked.text = self.book_count;
    [self.mCollectionView reloadData];
}

- (void)loadData{
    [SVProgressHUD show];
    [[HttpApi sharedInstance] getProfileInfo:pilot.userId Type:@"2" Completed:^(NSMutableDictionary *result){
        [SVProgressHUD dismiss];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSString *tf_str = [result objectForKey:@"tf_time"];
        if([tf_str isEqual:nil] || [tf_str isEqual:[NSNull null]])
            tf_str = @"0";
        NSNumber *tf_number = [f numberFromString:tf_str];
        self.tf_time = [tf_number stringValue];
        NSNumber *count_num = [result objectForKey:@"book_count"];
        self.book_count = [NSNumberFormatter localizedStringFromNumber:count_num numberStyle:NSNumberFormatterDecimalStyle];
        self.bookedArray = [[NSMutableArray alloc] init];
        NSMutableArray *datalist = [result objectForKey:@"airports"];
        for(int i = 0; i < datalist.count ; i++){
            NSString *name = [datalist[i] objectForKey:@"airport_name"];
            [self.bookedArray addObject:name];
        }
        [self setLayout];
    } Failed:^(NSString *errstr){
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - LOCATION MANAGER

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    mHomeCoordinate = location.coordinate;
    [self setAnnotation];
    [m_locationManager stopUpdatingLocation];
     [self getAddressFromLocation:mHomeCoordinate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bookedArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"RID_CProfileBookedItem";
    //UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    CProfileBookedItem *cell = [self.mCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.mNameLabel.text = [self.bookedArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (IBAction)onBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setAnnotation{
    if(mAnnotationArray.count > 0){
        [self.mMapView removeAnnotations:mAnnotationArray];
    }
    
    mAnnotationArray = [[NSMutableArray alloc] init];
    //========center position ==============
    
    ZSAnnotation *annotationC = [[ZSAnnotation alloc] init];
    annotationC.coordinate = mHomeCoordinate;
    annotationC.color = [UIColor redColor];
    annotationC.type = ZSPinAnnotationTypeStandard;//ZSPinAnnotationTypeDisc;//ZSPinAnnotationTypeTag;
    annotationC.title = @"Home";
    annotationC.tag = 1;
    [self.mMapView addAnnotation:annotationC];
    [mAnnotationArray addObject:annotationC];
    
    [self.mMapView showAnnotations:mAnnotationArray animated:YES];
}

#pragma mark - MapKit

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    
    // Don't mess with user location
    if(![annotation isKindOfClass:[ZSAnnotation class]])
        return nil;
    
    ZSAnnotation *a = (ZSAnnotation *)annotation;
    static NSString *defaultPinID = @"StandardIdentifier";
    
    // Create the ZSPinAnnotation object and reuse it
    ZSPinAnnotation *pinView = (ZSPinAnnotation *)[self.mMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if (pinView == nil){
        pinView = [[ZSPinAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    }
    
    // Set the type of pin to draw and the color
    pinView.annotationType = a.type;
    pinView.annotationColor = a.color;
    pinView.tag = a.tag;
    
    /*UIButton *disclosure = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
     
     [disclosure addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disclosureTapped)]];
     pinView.rightCalloutAccessoryView = disclosure;*/
    
    pinView.canShowCallout = YES;
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSInteger index = view.tag;
    if(index == -1)
        return;
}

- (void) getAddressFromLocation:(CLLocationCoordinate2D)location {
    [[LMGeocoder sharedInstance] reverseGeocodeCoordinate:location
                                                  service:kLMGeocoderGoogleService
                                        completionHandler:^(NSArray *results, NSError *error) {
                                            if (results.count && !error) {
                                                LMAddress *address = [results firstObject];
                                                NSString *locatedAt = [NSString stringWithFormat:@" %@, %@", address.locality, address.country];
                                                self.mAddressLabel.text = locatedAt;
                                            }
                                        }];
}
@end
