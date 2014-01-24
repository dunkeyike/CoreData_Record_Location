//
//  RootViewController.h
//  coredataSample
//
//  Created by Dunkey on 2014. 1. 23..
//  Copyright (c) 2014년 Dunkey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RootViewController : UITableViewController <CLLocationManagerDelegate> {
	// 역지오테깅 좌표(위도, 경도)->주소영 객체
	// 지오태깅은 보통 주소(또는 맵에서의 위치)->좌표(위도, 경도)
	CLGeocoder					*geocoder;
	// 주소를 저장하는 객체
	CLPlacemark					*placemark;
	// 테이블뷰에 표시하기위한 배열객체
	NSMutableArray				*eventsArray;
	// 위치정보를 받아오는 객체
	CLLocationManager			*locationManager;
	// 위치정보를 저장할때의 버튼
	UIBarButtonItem				*btnAdd;

}
// 코어데이터를 관리하는 객체
@property (nonatomic, retain) NSManagedObjectContext		*managedObjContext;
@end
