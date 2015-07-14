//
//  LBFHotel.h
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/27/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import "LBFModelObject.h"
#import <UIKit/UIKit.h>

@interface LBFHotel : LBFModelObject

@property (nonatomic, retain) NSString *direction;
@property (nonatomic, retain) NSString *distance;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *nightlyRate;
@property (nonatomic, retain) NSString *promotedNightlyRate;
@property (nonatomic, retain) NSString *promotedTotalRate;
@property (nonatomic, retain) NSString *starRating;
@property (nonatomic, retain) NSString *streetAddress;
@property (nonatomic, retain) NSString *thumbnail;
@property (nonatomic, retain) NSString *totalRate;

@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSNumber *masterId;
@property (nonatomic, retain) NSNumber *reviewScore;

@property (nonatomic, strong) UIImage *appIcon;

- (void)loadFromDictionary:(NSDictionary *)dictionary;
+ (LBFHotel *)findOrCreateHotelWithIdentifier:(NSString *)identifier
                                    inContext:(NSManagedObjectContext *)context;

@end
