//
//  CustomAnnotation.h
//  coredataSample
//
//  Created by Dunkey on 2014. 1. 24..
//  Copyright (c) 2014년 Dunkey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation :NSObject <MKAnnotation>
@property (readwrite, nonatomic) CLLocationCoordinate2D		coordinate;

@end

@implementation CustomAnnotation
@synthesize coordinate;

@end