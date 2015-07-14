//
//  LBFModelObject.m
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/27/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import "LBFModelObject.h"

@implementation LBFModelObject

// -------------------------------------------------------------------------------
//  entityName
//  @return class name for LBFModelObject
// -------------------------------------------------------------------------------
+ (id)entityName
{
    return NSStringFromClass(self);
}

// -------------------------------------------------------------------------------
//  insertNewObjectIntoContext
//  @param [in] context
//  @return instance of LBFModelObject
// -------------------------------------------------------------------------------
+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext*)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                         inManagedObjectContext:context];
}

@end
