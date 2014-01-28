//
//  HanabiEvent.h
//  coredataSample
//
//  Created by Dunkey on 2014. 1. 25..
//  Copyright (c) 2014년 Dunkey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface HanabiEvent : NSManagedObject

@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSNumber * open;
@property (nonatomic, retain) Event *hanabiEvent_event;

@end
