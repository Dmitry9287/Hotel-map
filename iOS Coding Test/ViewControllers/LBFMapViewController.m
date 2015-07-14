//
//  SecondViewController.m
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/27/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import "LBFMapViewController.h"
#import <MapKit/MapKit.h> 
#import "LBFAppDelegate.h"
#import "LBFHotel.h"
#import "LBFMapAnnotation.h"

static NSString *kAnnotationIdentifier = @"annotation";

@interface LBFMapViewController () <MKMapViewDelegate, LBFListViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation LBFMapViewController

#define METERS_PER_MILE 2.5*1609.344

#pragma mark object lifecycle

// -------------------------------------------------------------------------------
//	viewDidLoad
// -------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.mapView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_mapView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_mapView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapView]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_mapView)]];
    
    [self.mapView addAnnotations:[self createAnnotations]];
    [self zoomToLocation];
    
    LBFAppDelegate *appDelegate = (LBFAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.lbfListViewDelegate = self;
}

// -------------------------------------------------------------------------------
//	viewWillDisappear
// -------------------------------------------------------------------------------
- (void) viewWillDisappear:(BOOL)animated {
    
    // clear out selected hotel
    LBFAppDelegate *appDelegate = (LBFAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedHotel = nil;
    
    [super viewWillDisappear:animated];
}

#pragma mark map annotations

// -------------------------------------------------------------------------------
//	createAnnotations
//  Creates map annotations for each hotel
// -------------------------------------------------------------------------------
- (NSMutableArray *)createAnnotations
{
    LBFAppDelegate *appDelegate = (LBFAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    for (NSDictionary *row in appDelegate.persistentStack.fetchedResultsController.fetchedObjects) {
        
        LBFHotel *hotel = (LBFHotel *)row;
        NSNumber *latitude = hotel.latitude;
        NSNumber *longitude = hotel.longitude;
        NSString *title = hotel.name;
        NSString *key = hotel.key;
        UIImage *image = hotel.appIcon;
        
        //Create coordinates from the latitude and longitude values
        CLLocationCoordinate2D coord;
        coord.latitude = latitude.doubleValue;
        coord.longitude = longitude.doubleValue;
        
        LBFMapAnnotation *annotation = [[LBFMapAnnotation alloc] initWithTitle:title
                                                                 AndCoordinate:coord
                                                                        forKey:key
                                                                      forImage:image];
        [annotations addObject:annotation];
    }
    return annotations;
}

// -------------------------------------------------------------------------------
//	Zoom Map to user's current location
//  @note The simulator will show the user's location as being in California.
//        For the purpose of this demo, the app will statically zoom into Chicago.
//  @note The latitude and longitude values will typically come from the CLLocationManager location data
// -------------------------------------------------------------------------------
- (void)zoomToLocation
{
    CLLocationCoordinate2D zoomLocation;
    
    // The simulator will show the user's location as being in California.
    // For the purpose of this demo, the app will statically zoom into Chicago.
    // Ideally, the app will zoom to the user's real location
    zoomLocation.latitude = 41.8781136;
    zoomLocation.longitude= -87.6297982; 
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, METERS_PER_MILE, METERS_PER_MILE);
    [self.mapView setRegion:viewRegion
                   animated:YES];
    
    [self.mapView regionThatFits:viewRegion];
}

#pragma mark MKMapViewDelegate methods

// -------------------------------------------------------------------------------
//	mapView:viewForAnnotation:
//  Adds hotel's image to the map annotation
// -------------------------------------------------------------------------------
- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationIdentifier];
    
    if (![annotation isKindOfClass:[LBFMapAnnotation class]])
    {
        //annotation is NOT a "LBFMapAnnotation", return nil for default view...
        return nil;
    }
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:kAnnotationIdentifier];
        
        UIImageView *imageView =  [[UIImageView alloc] initWithImage:[(LBFMapAnnotation *)annotation image]];
        annotationView.leftCalloutAccessoryView = imageView;
    }
    
    annotationView.canShowCallout = YES;
    annotationView.annotation = annotation;
    return annotationView;
}

// -------------------------------------------------------------------------------
//	mapView:didAddAnnotationViews:
// -------------------------------------------------------------------------------
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    [self selectHotel];
}

#pragma mark LBFListViewDelegate methods

// -------------------------------------------------------------------------------
//	selectHotel
//  Displays selected hotel's annotation
// -------------------------------------------------------------------------------
- (void) selectHotel {
    LBFAppDelegate *appDelegate = (LBFAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    for(id annotation in self.mapView.annotations) {
        if( [annotation isKindOfClass:[LBFMapAnnotation class]]) {
            if([appDelegate.selectedHotel.key isEqualToString:[(LBFMapAnnotation *)annotation key]]) {
                [self.mapView selectAnnotation:annotation
                                      animated:YES];
                break;
            }
        }
    }
}

// -------------------------------------------------------------------------------
//	clearSelectedHotel
//  Removes selected hotel's annotation since it is no longer selected
// -------------------------------------------------------------------------------
- (void) clearSelectedHotel {
    for(id annotation in [self.mapView selectedAnnotations]) {
        [self.mapView deselectAnnotation:annotation
                                animated:YES];
    }
}

@end
