//
//  FirstViewController.m
//  iOS Coding Test
//
//  Created by Farran, Luke on 1/27/15.
//  Copyright (c) 2015 Farran, Luke. All rights reserved.
//

#import "LBFListViewController.h"
#import "LBFFetchedResultsControllerData.h"
#import "LBFHotel.h"
#import "LBFAppDelegate.h"
#import "LBFMapViewController.h"

NSUInteger const kMapIndex = 1;
NSUInteger const kListIndex = 0;

@interface LBFListViewController () <UIScrollViewDelegate, UITabBarControllerDelegate>
@property (nonatomic, strong) LBFFetchedResultsControllerData *dataSource;
@property (weak, nonatomic) IBOutlet UIBarButtonItem          *sortButton;
@property (nonatomic, strong) UIPopoverController             *sortPopover;

@end

@implementation LBFListViewController

// -------------------------------------------------------------------------------
//	viewDidLoad
//  Fetch hotel data and initialize UITableView's sort order for distance
//  Sets UITabBarController's delegate
// -------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
     LBFAppDelegate *appDelegate = (LBFAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self sortTable:@[[NSSortDescriptor sortDescriptorWithKey:@"totalRate"
                                                    ascending:YES]]];
    
    // Set UITabBarController's delegate
    UITabBarController *tabBarController = [[(UINavigationController *)[[appDelegate window] rootViewController] viewControllers] objectAtIndex:0];
    tabBarController.delegate = self;
}

// -------------------------------------------------------------------------------
//	didSelectRowAtIndexPath
//  Transition from the List UITableView to the Map view
//  The map view will display a pin for the selected indexPath row
// -------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBFAppDelegate* appDelegate = (LBFAppDelegate*)[[UIApplication sharedApplication] delegate];
    UITabBarController *tabBarController = [[(UINavigationController *)[[appDelegate window] rootViewController] viewControllers] objectAtIndex:0];
    UIView *fromView = tabBarController.selectedViewController.view;
    UIView *toView = [[tabBarController.viewControllers objectAtIndex:kMapIndex] view];
    
    appDelegate.selectedHotel = [self.dataSource objectAtIndexPath:indexPath];
    [appDelegate.lbfListViewDelegate selectHotel];
    
    // Transition to the map view
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = kMapIndex;
                        }
                    }];
}

#pragma mark sort button

// -------------------------------------------------------------------------------
//	didPressSort
//  @param [in] sender
//  Displays sort action sheet
// -------------------------------------------------------------------------------
- (IBAction)didPressSort:(id)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Sort Hotels by:"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *totalRate = [UIAlertAction actionWithTitle:@"Total Rate"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          [self sortTable:@[[NSSortDescriptor sortDescriptorWithKey:@"totalRate" ascending:YES]]];
                                                      }];
    [alert addAction:totalRate];
    
    
    UIAlertAction *distance = [UIAlertAction actionWithTitle:@"Distance"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          [self sortTable:@[[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES]]];
                                                      }];
    [alert addAction:distance];
    
    // Star rating from highest to lowest, using hotel name as a secondary sort key
    UIAlertAction *starRating = [UIAlertAction actionWithTitle:@"Star Rating"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self sortTable:@[[NSSortDescriptor sortDescriptorWithKey:@"starRating" ascending:NO],
                                                                           [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
                                                     }];
    [alert addAction:starRating];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                    style:UIAlertActionStyleCancel
                                                  handler:^(UIAlertAction * action) {}];
    [alert addAction:cancel];
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        self.sortPopover = [[UIPopoverController alloc] initWithContentViewController:alert];
        self.sortPopover.delegate = self;
        
        // Present the popover from the button that was tapped in the channel view.
        [self.sortPopover presentPopoverFromBarButtonItem:sender
                                 permittedArrowDirections:UIPopoverArrowDirectionUp
                                                 animated:YES];
    }
    else {
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    }
}

// -------------------------------------------------------------------------------
//	sortTable
//  @param [in] descriptors - Array of sort options
//  Fetches the hotel data and refrehes UITableView with the new sort order
// -------------------------------------------------------------------------------
- (void) sortTable:(NSArray *)descriptors {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LBFHotel"];
    request.sortDescriptors = descriptors;
    self.dataSource = [[LBFFetchedResultsControllerData alloc] initWithTableView:self.tableView];
    LBFAppDelegate *appDelegate = (LBFAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.dataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                   managedObjectContext:appDelegate.persistentStack.backgroundManagedObjectContext
                                                                                     sectionNameKeyPath:nil
                                                                                              cacheName:nil];
    
    appDelegate.persistentStack.fetchedResultsController = self.dataSource.fetchedResultsController;
    [self.tableView reloadData];
}

#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
       [self.dataSource loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:scrollView
//  When scrolling stops, proceed to load the app icons that are on screen.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   [self.dataSource loadImagesForOnscreenRows];
}

#pragma mark UITabBarController Delegate 

// -------------------------------------------------------------------------------
//	tabBarController:didSelectViewController
//  Clears the selected hotel when switching between the UITabBarController's views
// -------------------------------------------------------------------------------
- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController {
    
    LBFAppDelegate* appDelegate = (LBFAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedHotel = nil;
    
    if([appDelegate.lbfListViewDelegate respondsToSelector:@selector(clearSelectedHotel)]) {
        [appDelegate.lbfListViewDelegate clearSelectedHotel];
    }
}

// -------------------------------------------------------------------------------
//	tabBarController:shouldSelectViewController
//  Ignores taps on the UITabBar if it's for selecting the currently selected view
//  This prevents the map's selected hotel from being cleared on accident
// -------------------------------------------------------------------------------
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        viewController = [nav.viewControllers objectAtIndex:0];
    }
    
    if( kMapIndex == tabBarController.selectedIndex &&
       [viewController isKindOfClass:[LBFMapViewController class]]) {
        return NO;
    }
    else if( kListIndex == tabBarController.selectedIndex &&
             [viewController isKindOfClass:[LBFListViewController class]] ) {
        return NO;
    }
    else {
        return YES;
    }
}

@end
