//
//  LBFHotel.m
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/27/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import "LBFHotel.h"

@implementation LBFHotel

@dynamic direction;
@dynamic distance;
@dynamic identifier; 
@dynamic key;
@dynamic name;
@dynamic nightlyRate;
@dynamic promotedNightlyRate;
@dynamic promotedTotalRate;
@dynamic starRating;
@dynamic streetAddress;
@dynamic thumbnail;
@dynamic totalRate;

@dynamic latitude;
@dynamic longitude;
@dynamic masterId;
@dynamic reviewScore;

@dynamic appIcon;

// -------------------------------------------------------------------------------
//  loadFromDictionary
//  @param [in] dictionary
//  Loads data from hotels.json for hotel into LBFHotel object
// -------------------------------------------------------------------------------
- (void)loadFromDictionary:(NSDictionary *)dictionary
{
    self.distance = dictionary[@"distance"];
    self.direction = dictionary[@"direction"];
    self.starRating = dictionary[@"star_rating"];
    self.name = dictionary[@"name"];
    self.nightlyRate = dictionary[@"nightly_rate"];
    self.promotedNightlyRate = dictionary[@"promoted_nightly_rate"];
    self.totalRate = dictionary[@"total_rate"];
    self.longitude = dictionary[@"longitude"];
    self.key = dictionary[@"key"];
    self.promotedTotalRate = dictionary[@"promoted_total_rate"];
    self.latitude = dictionary[@"latitude"];
    self.masterId = dictionary[@"master_id"];
    self.thumbnail = dictionary[@"thumbnail"];
    self.streetAddress = dictionary[@"street_address"];
    self.reviewScore = dictionary[@"review_score"];
}

// -------------------------------------------------------------------------------
//  findOrCreateHotelWithIdentifier:inContext
//  @param [in] identifier
//  @param [in] context
//  @return hotel object 
// -------------------------------------------------------------------------------
+ (LBFHotel *)findOrCreateHotelWithIdentifier:(NSString *)identifier
                                    inContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest
                                             error:&error];
    
    if (result.lastObject) {
        return result.lastObject;
    }
    else {
        LBFHotel *hotel = [self insertNewObjectIntoContext:context];
        hotel.identifier = identifier;
        return hotel;
    }
}

@end
