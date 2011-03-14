//
//  MapViewController.m
//  ImageEditing
//
//  Created by gaurav sinha on 01/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController
@synthesize locManager;
@synthesize mapView,arrayLat,arrayLong;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	//39.7757, -93.1773
	
	[self.navigationItem setTitle:@"Map"];
	mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
	[self.view insertSubview:mapView atIndex:1];
	
	mapView.showsUserLocation=FALSE;
	mapView.mapType	= MKMapTypeStandard;
	[self.mapView setDelegate:self];
	//mapView.delegate   =  self;
	/*Region and Zoom*/
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.3;
	span.longitudeDelta=0.3;
	
	
	for(int i=0;i<[arrayLat count];i++)
	{
		location.latitude = [[arrayLat objectAtIndex:i] floatValue];
		location.longitude = [[arrayLong objectAtIndex:i] floatValue];
		region.span=span;
		self.mapView.showsUserLocation = TRUE;
		self.mapView.zoomEnabled	   = YES;
		
		region.center=location;
		[self.mapView setRegion:region animated:TRUE];
		[self.mapView regionThatFits:region];
		
		MyAnnotation *addAnnotation	   = [[[MyAnnotation alloc] initWithCoordinate:location ] retain];
		//[addAnnotation setTitle:[[arrayForMap objectAtIndex:i] objectForKey:@"store_name"]];
		//[addAnnotation setTitle:@"Vinsol" ];
		[self.mapView addAnnotation:addAnnotation];
	
	}
    [super viewDidLoad];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation
{
	NSString *string   =   mPlacemark.locality;
	
	MKPinAnnotationView *annView = nil;
	//MyAnnotation *annotationView = nil;
	
	
	//if (annotation == mapView.userLocation)
	//	{
	//		return annotationView;
	//	}
	
	
	//MyAnnotation* myAnnotation = (MyAnnotation *)annotation;
	annView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:string] autorelease];
	
	(MKPinAnnotationView *)[mapview dequeueReusableAnnotationViewWithIdentifier:string];
	
	// If we have to, create a new view
	
	annView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:string] autorelease];
	//MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:string];  
	
	annView.canShowCallout = YES;  
		
	annView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[annView setPinColor:MKPinAnnotationColorPurple];
	annView.calloutOffset = CGPointMake(-5, 5);
	annView.animatesDrop=TRUE; 
	return annView;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
