//
//  LBFMapAnnotation.h
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/29/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LBFMapAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *key;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, weak) UIImage *image;

-(id) initWithTitle:(NSString *) title
      AndCoordinate:(CLLocationCoordinate2D)coordinate
             forKey:(NSString *) key
           forImage:(UIImage *)image;

@end

