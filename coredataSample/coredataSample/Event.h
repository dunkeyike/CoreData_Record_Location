//
//  Event.h
//  coredataSample
//
//  Created by Dunkey on 2014. 1. 25..
//  Copyright (c) 2014년 Dunkey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GolfEvent, HanabiEvent;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * locationname;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) HanabiEvent *event_hanabiEvent;
@property (nonatomic, retain) NSSet *event_golfEvent;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addEvent_golfEventObject:(GolfEvent *)value;
- (void)removeEvent_golfEventObject:(GolfEvent *)value;
- (void)addEvent_golfEvent:(NSSet *)values;
- (void)removeEvent_golfEvent:(NSSet *)values;

@end
