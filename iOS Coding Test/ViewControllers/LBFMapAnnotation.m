//
//  LBFMapAnnotation.m
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/29/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import "LBFMapAnnotation.h"

@implementation LBFMapAnnotation

-(id) initWithTitle:(NSString *) title
      AndCoordinate:(CLLocationCoordinate2D)coordinate
             forKey:(NSString *)key
           forImage:(UIImage *)image
{
    self =  [super init];
    self.title = title;
    self.coordinate = coordinate;
    self.key = key;
    self.image = image;
    return self;
}

@end

