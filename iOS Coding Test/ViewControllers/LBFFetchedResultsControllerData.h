//
//  LBFFetchedResultsData.h
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/28/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class NSFetchedResultsController;

@interface LBFFetchedResultsControllerData : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) BOOL paused;

- (id)initWithTableView:(UITableView*)tableView;
- (id)objectAtIndexPath:(NSIndexPath*)indexPath;
- (id)selectedItem;
- (void)loadImagesForOnscreenRows;

@end
