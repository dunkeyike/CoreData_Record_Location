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
	CLGeocoder					*geocoder;
	CLPlacemark					*placemark;
	NSMutableArray				*eventsArray;
	CLLocationManager				*locationManager;
	UIBarButtonItem				*btnAdd;

}
@property (nonatomic, retain) NSManagedObjectContext		*managedObjContext;
@end
