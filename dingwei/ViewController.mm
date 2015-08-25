//
//  ViewController.m
//  dingwei
//
//  Created by chedao on 15/8/13.
//  Copyright (c) 2015年 chedao. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "BMapKit.h"
#import "CoorModel.h"

@interface ViewController ()<CLLocationManagerDelegate,BMKLocationServiceDelegate,BMKMapViewDelegate>{


    BMKMapView *_mapView;
    BMKLocationService *_locService;
    NSMutableArray *dataArr;
    
}



@property(nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];

    
    dataArr = [NSMutableArray array];
    [self startLocationService];
}
-(void)startLocationService{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        _locationManager = [[CLLocationManager alloc] init];
        //获取授权验证
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
    }
    
    
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    
    _mapView.showsUserLocation = YES;
    
}
-(void)willStartLocatingUser{

    NSLog(@"skd'ks");

}

-(void)didUpdateUserLocation:(BMKUserLocation *)userLocation{

    [_mapView updateLocationData:userLocation];
    CLLocationCoordinate2D pt = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    _mapView.centerCoordinate = pt;
    CoorModel *model = [[CoorModel alloc] init];
    model.latitude = pt.latitude;
    model.longitude = pt.longitude;
    [dataArr addObject:model];
    NSLog(@"%@   %f    %f",dataArr,model.latitude,model.longitude);
    [self makeline];
}


-(void)makeline{

    if ( dataArr.count < 2 ) {
        return;
    }
    BMKMapPoint *pointarr = new BMKMapPoint[dataArr.count];
    
    for (int i = 0; i < dataArr.count; i++) {
        CoorModel *model = dataArr[i];
         CLLocationCoordinate2D pt = CLLocationCoordinate2DMake(model.latitude, model.longitude);
        BMKMapPoint point = BMKMapPointForCoordinate(pt);
        pointarr[i] = point;
    }
    
    BMKPolyline *polyline;
    if (polyline) {
        [_mapView removeOverlay:polyline];
    }
    polyline = [BMKPolyline polylineWithPoints:pointarr count:dataArr.count];
    if (nil != polyline) {
        [_mapView addOverlay:polyline];
    }
    
    delete [] pointarr;

}
-(BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id)overlay {
    
        BMKPolylineView * polyLineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polyLineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
        polyLineView.lineWidth = 5.0;
        
        return polyLineView;
       return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
