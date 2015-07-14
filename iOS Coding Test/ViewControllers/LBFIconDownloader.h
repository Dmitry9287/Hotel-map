//
//  LBFIconDownloader.h
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/28/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LBFHotel;

@interface LBFIconDownloader : NSObject

@property (nonatomic, strong) LBFHotel *hotel;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end
