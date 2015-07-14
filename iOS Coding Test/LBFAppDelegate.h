//
//  AppDelegate.h
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/27/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBFPersistentStack.h"
#import "LBFLocationObject.h"
#import "LBFHotel.h"
#import "LBFListViewController.h"

@interface LBFAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow              *window;
@property (nonatomic, strong) LBFPersistentStack    *persistentStack;
@property (nonatomic, strong) LBFLocationObject     *locationHelper;
@property (nonatomic, weak)   LBFHotel              *selectedHotel;
@property (nonatomic, weak) id<LBFListViewDelegate> lbfListViewDelegate;

@end

