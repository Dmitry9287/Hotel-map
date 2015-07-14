# iOS-Map-Demo
Objective-C iOS demo app that uses Core Location, Core Data, and MapKit.  The app reads in hotel data into Core Data from a JSON file.  Hotel data can be displayed in a list or map views.  The list view is implemented with a UITableViewController and is sortable by cost, distance, and star rating.  Map data is displayed in a MKMapVIew.

## Assumptions / Limitations:
* Universal app for iPhone and iPad using a UITabBarController.  A UISplitViewController was not used for the iPad presentation.
* List view's UITableViewCell's are not editable and can't edit/delete hotels.
* The sort mechanism is initiated via a button that uses a UIPopoverControllerDelegate.  Ideally, the iPhone's instance of this view controller would not have this.
* The sort option for distance is using static data stored from the JSON file.  Real apps would read the user's location and update the data model appropriately.  However, in the simulator the user's location points to California.  
* The map view statically zooms into Chicago via the LBFMapViewControlller's zoomToLocation method.  Again, this was done since the CLCoreLocationManager simulates a user being in California.  Since all of the hotel data is for Chicago, it made sense to demo the feature this way.
* No localization for multi-language support.
* The list view's sort order is not persistently stored. 
* UX styling is kept to a minimum.
* All device orientations are supported.
* Persistent caching does not occur for future app launches because it seems that the real use case is for finding data relative to the user's location and would be dynamically served up from a backend server.
* Lacks unit tests. 

