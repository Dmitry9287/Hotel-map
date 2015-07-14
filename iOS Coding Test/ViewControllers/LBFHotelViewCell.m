//
//  LBFHotelViewCell.m
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/29/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import "LBFHotelViewCell.h"

@implementation LBFHotelViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    // ignore the style argument and force the creation with style UITableViewCellStyleSubtitle
    return [super initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:reuseIdentifier];
}

@end
