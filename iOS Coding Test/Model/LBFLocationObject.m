//
//  LBFLocationObject.m
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/29/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import "LBFLocationObject.h"

@implementation LBFLocationObject

// -------------------------------------------------------------------------------
//  init
//  @return instance of LBFLocationObject
// -------------------------------------------------------------------------------
- (id) init {
    self = [super init];
    if (self) {
        [self startLocationManager];
    }
    return self;
}

#pragma location

// -------------------------------------------------------------------------------
//  startLocationManager
//  Starts CLLocationManager
// -------------------------------------------------------------------------------
- (void) startLocationManager {
    
    //Checks if Location Services are Enabled
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        
        // Set a movement threshold for new events.
        self.locationManager.distanceFilter = 500; // meters
        [self.locationManager startUpdatingLocation];
        
        // method is only supported in iOS8
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
}

#pragma CLLocationManagerDelegate

// -------------------------------------------------------------------------------
//  locationManager:didUpdateLocations
//  Handles location change events
//  @note Currently only used for debug.
//  In a real App, this method could be used to update the hotel objects distance property
// -------------------------------------------------------------------------------
/*- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {

    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}*/

@end
