//
//  LBFListViewController.h
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/27/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LBFFetchedResultsControllerData;

@protocol LBFListViewDelegate<NSObject>
@required
- (void) selectHotel;
- (void) clearSelectedHotel;
@end

@interface LBFListViewController : UITableViewController<UIPopoverControllerDelegate>

@end

