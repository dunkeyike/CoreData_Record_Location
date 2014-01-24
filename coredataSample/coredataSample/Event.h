//
//  Event.h
//  coredataSample
//
//  Created by Dunkey on 2014. 1. 23..
//  Copyright (c) 2014년 Dunkey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * locationname;

@end
