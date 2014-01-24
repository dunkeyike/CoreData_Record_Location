//
//  DetailViewController.h
//  coredataSample
//
//  Created by Dunkey on 2014. 1. 24..
//  Copyright (c) 2014년 Dunkey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface DetailViewController : UIViewController <MKMapViewDelegate>

// 테이블뷰에서 위치 정보를 받아올 위치정보
@property (nonatomic, assign) CLLocationCoordinate2D location;
// 맵뷰
@property (nonatomic, strong) IBOutlet MKMapView			*mapView;
// 테이블뷰에서 위치 정보를 받아올 위치의 주소
@property (nonatomic, retain) NSString *addressName;
@end
