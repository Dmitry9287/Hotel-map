//
//  LBFJsonImporter.m
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/27/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import "LBFJsonImporter.h"
#import "LBFHotel.h"
#import "LBFIconDownloader.h" 

@interface LBFJsonImporter()
@property (nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation LBFJsonImporter

// -------------------------------------------------------------------------------
//	initWithContext
//  @param [in] context
//  @return instance of LBFJsonImporter
// -------------------------------------------------------------------------------
- (id)initWithContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (self) {
        self.context = context;
        [self import];
    }
    return self;
}

// -------------------------------------------------------------------------------
//  import
//  Reads in data from hotels.json file and creates an object for each hotel
// -------------------------------------------------------------------------------
- (void)import {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hotels"
                                                     ofType:@"json"];
    
    NSError *error = nil;
    NSData *json = [NSData dataWithContentsOfFile:path];
    id object = [NSJSONSerialization JSONObjectWithData:json
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];
    if([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *data = (NSDictionary *)object;
        NSDictionary *hotels = [data objectForKey:@"hotels"];
        
        for(NSDictionary *hotel in hotels) {
            NSString *identifier = [hotel[@"name"] stringByAppendingString:hotel[@"key"]];
            LBFHotel *lbfHotel = [LBFHotel findOrCreateHotelWithIdentifier:identifier
                                                                 inContext:self.context];
            [lbfHotel loadFromDictionary:hotel];
            [self downloadHotelImage:lbfHotel];
        }
    }
}

// -------------------------------------------------------------------------------
//  downloadHotelImage
//  Download the hotel image
// -------------------------------------------------------------------------------
- (void) downloadHotelImage:(LBFHotel *)hotel {
    LBFIconDownloader *iconDownloader;
    
    if (iconDownloader == nil) {
        iconDownloader = [[LBFIconDownloader alloc] init];
        iconDownloader.hotel = hotel;
        [iconDownloader startDownload];
    }
}

@end
