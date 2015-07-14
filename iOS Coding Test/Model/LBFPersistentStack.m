//
//  LBFPersistentStack.m
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/28/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import "LBFPersistentStack.h"


@interface LBFPersistentStack ()

@property (nonatomic,readwrite) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,readwrite) NSManagedObjectContext* backgroundManagedObjectContext;

@end

@implementation LBFPersistentStack

// -------------------------------------------------------------------------------
//	init
//  @return instance of LBFPersistentStack
// -------------------------------------------------------------------------------
- (id) init
{
    self = [super init];
    if (self) {
        [self setupManagedObjectContexts];
    }
    return self;
}

// -------------------------------------------------------------------------------
//	setupManagedObjectContexts
// -------------------------------------------------------------------------------
- (void)setupManagedObjectContexts
{
    self.managedObjectContext = [self setupManagedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
    
    self.backgroundManagedObjectContext = [self setupManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.backgroundManagedObjectContext.undoManager = nil;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification* note) {
                                                      NSManagedObjectContext *moc = self.managedObjectContext;
                                                      if (note.object != moc) {
                                                          [moc performBlock:^(){
                                                              [moc mergeChangesFromContextDidSaveNotification:note];
                                                          }];
                                                      }
                                                  }];
}

// -------------------------------------------------------------------------------
//	setupManagedObjectContextWithConcurrencyType
//  @param [in] concurrencyType
//  @return managedObjectContext
// -------------------------------------------------------------------------------
- (NSManagedObjectContext *)setupManagedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
{
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
    managedObjectContext.persistentStoreCoordinator =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSError* error;
    [managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                  configuration:nil
                                                                            URL:self.storeURL
                                                                        options:nil
                                                                          error:&error];
    return managedObjectContext;
}

// -------------------------------------------------------------------------------
//	managedObjectModel
//  @return managedObjectModel
// -------------------------------------------------------------------------------
- (NSManagedObjectModel*)managedObjectModel
{
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
}

// -------------------------------------------------------------------------------
//	storeURL
//  @return NSURL for db.sqlite storage
// -------------------------------------------------------------------------------
- (NSURL*)storeURL
{
    NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                       inDomain:NSUserDomainMask
                                                              appropriateForURL:nil
                                                                         create:YES
                                                                          error:NULL];
    //NSLog(@"storeURL %@", documentsDirectory);
    return [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
}

// -------------------------------------------------------------------------------
//	modelURL
//  @return NSURL for Hotels.xcdatamodleid
// -------------------------------------------------------------------------------
- (NSURL*)modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"Hotels"
                                   withExtension:@"momd"];
}

@end
