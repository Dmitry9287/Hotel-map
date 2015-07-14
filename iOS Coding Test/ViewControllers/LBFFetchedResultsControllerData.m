//
//  LBFFetchedResultsData.m
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/28/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import "LBFFetchedResultsControllerData.h"
#import "LBFHotel.h"
#import "LBFIconDownloader.h"
#import "LBFHotelViewCell.h"

static NSString *kCellIdentifier = @"Cell";
static NSString *kPlaceholderCellIdentifier = @"PlaceholderCell";

@interface LBFFetchedResultsControllerData () 
@property (nonatomic, strong) UITableView *tableView;

// the set of IconDownloader objects for each hotel
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@end

@implementation LBFFetchedResultsControllerData

// -------------------------------------------------------------------------------
//	initWithTableView
//  @param [in] tableView
//  @return instance of LBFFetchedResultsControllerData
// -------------------------------------------------------------------------------
- (id)initWithTableView:(UITableView*)tableView
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.tableView.dataSource = self;
        
        [self.tableView registerClass:[LBFHotelViewCell class]
               forCellReuseIdentifier:kCellIdentifier];
        [self.tableView registerClass:[LBFHotelViewCell class]
               forCellReuseIdentifier:kPlaceholderCellIdentifier];
        
        self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    }
    return self;
}

// -------------------------------------------------------------------------------
//	terminateAllDownloads
// -------------------------------------------------------------------------------
- (void)terminateAllDownloads
{
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

// -------------------------------------------------------------------------------
//	dealloc
//  If this view controller is going away, we need to cancel all outstanding downloads.
// -------------------------------------------------------------------------------
- (void)dealloc
{
    // terminate all pending download connections
    [self terminateAllDownloads];
}

#pragma mark - UITableViewDataSource

// -------------------------------------------------------------------------------
//	numberOfSectionsInTableView
//  UITableViewDataSource delegate method
// -------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.fetchedResultsController.sections.count;
}

// -------------------------------------------------------------------------------
//	tableView:numberOfRowsInSection:
//  Customize the number of rows in the table view.
// -------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[sectionIndex];
    return section.numberOfObjects;
}

// -------------------------------------------------------------------------------
//	tableView:cellForRowAtIndexPath:
// -------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    LBFHotelViewCell *cell = nil;
    
    NSUInteger nodeCount = [self.fetchedResultsController.fetchedObjects count];
    
    if (nodeCount == 0 && indexPath.row == 0)
    {
        // add a placeholder cell while waiting on table data
        cell = [tableView dequeueReusableCellWithIdentifier:kPlaceholderCellIdentifier
                                               forIndexPath:indexPath];
        
        cell.detailTextLabel.text = @"Loading…";
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                               forIndexPath:indexPath];
        
        // Leave cells empty if there's no data yet
        if (nodeCount > 0)
        {
            // Set up the cell representing the app
            LBFHotel *hotel = (LBFHotel *)[self objectAtIndexPath:indexPath];
            cell.textLabel.text = hotel.name;
            
            // Only load cached images; defer new downloads until scrolling ends
            if (!hotel.appIcon)
            {
                if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
                {
                    [self startIconDownload:hotel
                               forIndexPath:indexPath];
                }
                
                // if a download is deferred or in progress, return a placeholder image
                cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
            }
            else
            {
                cell.imageView.image = hotel.appIcon;
            }
        }
    }
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    [cell setBackgroundColor:[UIColor colorWithRed:0.937 green:0.937 blue:0.984 alpha:1]]; /*#efeffb*/
    cell.imageView.clipsToBounds = YES;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
}

// -------------------------------------------------------------------------------
//	objectAtIndexPath
//  @param [in] indexPath
// -------------------------------------------------------------------------------
- (id)objectAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

// -------------------------------------------------------------------------------
//	tableView:canEditRowAtIndexPath:
//  @param [in] tableView
//  @param [in] indexPath
//  @return NO
// -------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return NO;
}


#pragma mark NSFetchedResultsControllerDelegate

// -------------------------------------------------------------------------------
//	controllerWillChangeContent
//  @param [in] controller
//  @note This would be used if live network updates were occurring
// -------------------------------------------------------------------------------
- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView beginUpdates];
}

// -------------------------------------------------------------------------------
//	controllerDidChangeContent
//  @param [in] controller
//  @note This would be used if live network updates were occurring
// -------------------------------------------------------------------------------
- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView endUpdates];
}

// -------------------------------------------------------------------------------
//	controller:didChangeObject:atIndexPath:newIndexPath:
//  @note This would be used if live network updates were occurring
// -------------------------------------------------------------------------------
- (void)controller:(NSFetchedResultsController*)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath*)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath*)newIndexPath
{
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (type == NSFetchedResultsChangeMove) {
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    }
    else if (type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (type == NSFetchedResultsChangeUpdate) {
        if ([self.tableView.indexPathsForVisibleRows containsObject:indexPath]) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } else {
        NSAssert(NO,@"");
    }
}

// -------------------------------------------------------------------------------
//	setFetchedResultsController:
//  @param [in] fetchedResultsController
// -------------------------------------------------------------------------------
- (void)setFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController
{
    NSAssert(_fetchedResultsController == nil, @"You can currently only assign this property once");
    _fetchedResultsController = fetchedResultsController;
    fetchedResultsController.delegate = self;
    [fetchedResultsController performFetch:NULL];
}

// -------------------------------------------------------------------------------
//	selectedItem
//  @todo Could be used to replace the LBFAppDelegate's selectedHotel property
// -------------------------------------------------------------------------------
- (id)selectedItem
{
    NSIndexPath* path = self.tableView.indexPathForSelectedRow;
    return path ? [self.fetchedResultsController objectAtIndexPath:path] : nil;
}

// -------------------------------------------------------------------------------
//	setPaused
//  @param [in] paused
// -------------------------------------------------------------------------------
- (void)setPaused:(BOOL)paused
{
    _paused = paused;
    if (paused) {
        self.fetchedResultsController.delegate = nil;
    }
    else {
        self.fetchedResultsController.delegate = self;
        [self.fetchedResultsController performFetch:NULL];
        [self.tableView reloadData];
    }
}

#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(LBFHotel *)hotel
             forIndexPath:(NSIndexPath *)indexPath
{
    LBFIconDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    
    if (iconDownloader == nil) {
        iconDownloader = [[LBFIconDownloader alloc] init];
        iconDownloader.hotel = hotel;
        [iconDownloader setCompletionHandler:^{
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imageView.image = hotel.appIcon;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    if ([self.fetchedResultsController.fetchedObjects count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            LBFHotel *hotel = (self.fetchedResultsController.fetchedObjects)[indexPath.row];
            
            // Avoid the app icon download if the app already has an icon
            if (!hotel.appIcon)
            {
                [self startIconDownload:hotel
                           forIndexPath:indexPath];
            }
        }
    }
}

@end
