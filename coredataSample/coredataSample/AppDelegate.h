//
//  AppDelegate.h
//  coredataSample
//
//  Created by Dunkey on 2014. 1. 23..
//  Copyright (c) 2014년 Dunkey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
	UINavigationController			*navigationController;
}
@property (nonatomic, retain) UINavigationController	*navigationController;

@property (strong, nonatomic) UIWindow *window;

// 템플릿에서 코어데이터 사용을 체크하면 자동으로 생기는 객체들
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
