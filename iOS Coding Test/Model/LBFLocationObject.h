//
//  LBFLocationObject.h
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/29/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface LBFLocationObject : NSObject <CLLocationManagerDelegate>
@property(nonatomic, retain)  CLLocationManager *locationManager;
@end
