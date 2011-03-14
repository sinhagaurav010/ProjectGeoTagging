//
//  MapViewController.h
//  ImageEditing
//
//  Created by gaurav sinha on 01/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
@interface MapViewController : UIViewController<MKMapViewDelegate> {
	CLLocationManager *locManager;
	IBOutlet MKMapView *mapView;
	MKPlacemark *mPlacemark;
	NSMutableArray *arrayLat;
	NSMutableArray *arrayLong;
	CLLocationCoordinate2D location;
}
@property (retain) CLLocationManager *locManager;
@property (nonatomic, retain)IBOutlet MKMapView *mapView;
@property (nonatomic,retain)NSMutableArray *arrayLat;
@property (nonatomic,retain)NSMutableArray *arrayLong; 
@end
