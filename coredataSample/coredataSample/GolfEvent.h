//
//  GolfEvent.h
//  coredataSample
//
//  Created by Dunkey on 2014. 1. 25..
//  Copyright (c) 2014년 Dunkey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface GolfEvent : NSManagedObject

@property (nonatomic, retain) NSString * golfEventName;
@property (nonatomic, retain) Event *golfEvent_event;

@end
