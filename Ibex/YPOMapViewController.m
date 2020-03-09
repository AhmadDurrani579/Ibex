//
//  YPOMapViewController.m
//  Ibex
//
//  Created by Ahmed Durrani on 28/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOMapViewController.h"
@import GoogleMaps;


@interface YPOMapViewController ()<GMSMapViewDelegate , CLLocationManagerDelegate>
{
    double latitudes;
    double longitudes;

    CLLocationManager *locationManager;
    __weak IBOutlet UILabel *titleOfMap;
    __weak IBOutlet UILabel *venuAddress;
    double latdouble ;
    double longDouble ;
    
    
}
@property (weak, nonatomic) IBOutlet GMSMapView *mapViews;


@end

@implementation YPOMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    if (_selectedVc == 2) {
        titleOfMap.text = self.scheduleObj.name ;
        venuAddress.text = self.scheduleObj.venueAddress ;
       latdouble  = [self.scheduleObj.venueLat doubleValue];
       longDouble = [self.scheduleObj.venueLng doubleValue];

    } else {
        titleOfMap.text = self.eventObj.eventName ;
        venuAddress.text = self.eventObj.eventVenueAddress ;
        latdouble  = [self.eventObj.eventVenueLat doubleValue];
        longDouble = [self.eventObj.eventVenueLong doubleValue];
    }
    
    
    [_mapViews setMapType:kGMSTypeNormal];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latdouble
                                                                longitude: longDouble
                                                                     zoom:14];
        [_mapViews animateToCameraPosition:camera];
        _mapViews.myLocationEnabled = YES;
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(latdouble, longDouble);
        marker.map = _mapViews;

    
    });

    
  

}
- (IBAction)btnBack_Pressed:(UIButton *)sender {
      [self.navigationController popViewControllerAnimated:true];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
