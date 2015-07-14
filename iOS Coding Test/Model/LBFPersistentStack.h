//
//  LBFPersistentStack.h
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/28/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LBFPersistentStack : NSObject

@property (nonatomic,readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,readonly) NSManagedObjectContext* backgroundManagedObjectContext;
@property (nonatomic, strong)  NSFetchedResultsController *fetchedResultsController; 

@end
