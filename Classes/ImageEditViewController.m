//
//  ImageEditViewController.m
//  ImageEditing
//
//  Created by gaurav sinha on 15/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageEditViewController.h"
#import "MapViewController.h"

#define NUM 3
#define HEIGHT 398
#define ZOOM_STEP 4

@implementation ImageEditViewController

@synthesize scroll_View,tapRecognizer;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;

*/
- (BOOL) isMultipleTouchEnabled {return YES;}


/////////////////////////

#pragma mark -
#pragma mark locationManager


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	
		
	////Array of images
	arrayImages = [NSMutableArray new];
	[arrayImages addObject:@"Santa_Monica_Beach-California.jpg"];
	[arrayImages addObject:@"california.jpg"];
	[arrayImages addObject:@"los-angeles.jpg"];
	
	
	//////Code for the button to give the option to user
	UIBarButtonItem *newButton				= [[UIBarButtonItem alloc] initWithTitle: @"Options" style: UIBarButtonItemStyleBordered target:self action:@selector(presstoSave:)];
	self.navigationItem.rightBarButtonItem	= newButton;
	[newButton release];
	
	self.navigationController.navigationBar.tintColor  = [UIColor  blackColor];
	[self.navigationItem setTitle:@"Image Edit"];
	
	/////Scroll View To Check the page  
	scroll_View.delegate = self;
	scroll_View.contentSize = CGSizeMake(320*NUM+30, HEIGHT-10);
	scroll_View.userInteractionEnabled = YES;
	scroll_View.pagingEnabled = YES;
	
	
	/////Array to store the imageView
	arrayImageView = [NSMutableArray new];
	//Set the navigation title
	[self navigationTitleSet:1];

	arrayScroll = [NSMutableArray new];///Array to store the ScrollView for zooming
	
	///longitude and latitude
	arrayLat = [[NSMutableArray alloc] init];
	arrayLong = [[NSMutableArray alloc] init];
	
	
	/////Code for scroll view for zooming 
	for(int i = 0;i<[arrayImages count];i++)
	{
		[arrayLong addObject:@"-93.1773"];
		[arrayLat addObject:@"39.7757"];
		[self scrollViewZoom:(UIImage*)[UIImage imageNamed:[arrayImages objectAtIndex:i]]];	
	}
	///////////////
    [super viewDidLoad];
}


#pragma mark -
#pragma mark scrolviewzooming

-(void)scrollViewZoom:(UIImage*)image
{
	static int incX = 10;
	imageView			= [[UIImageView alloc] initWithFrame:CGRectMake(0,10, 300, HEIGHT-50)];
	imageView.image		= image;
	
	UIScrollView *scrollViewForZooming  =  [UIScrollView new];
	scrollViewForZooming.frame		=  CGRectMake(incX,10, 300, HEIGHT);
	scrollViewForZooming.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
	scrollViewForZooming.maximumZoomScale = ZOOM_STEP;
	[scrollViewForZooming setTag:1];
	scrollViewForZooming.minimumZoomScale = 1;
	scrollViewForZooming.clipsToBounds	 = YES;
	[scrollViewForZooming addSubview:imageView];
	scrollViewForZooming.delegate = self;
	
	
	UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	[doubleTap setNumberOfTapsRequired:2];
	[scrollViewForZooming addGestureRecognizer:doubleTap];
	
	
	[scroll_View addSubview:scrollViewForZooming];
	[arrayScroll addObject:scrollViewForZooming];
	
    scrollViewForZooming.userInteractionEnabled = YES;
	[arrayImageView addObject:imageView];
	incX += 320;
	
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center 
{	
    UIScrollView *imageScrollView = [[UIScrollView  alloc] init];
	imageScrollView = (UIScrollView*)[arrayScroll objectAtIndex:_which_image];

    CGRect zoomRect;
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.	
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.

    zoomRect.size.height = [imageScrollView frame].size.height / scale;	
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;

    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
	return zoomRect;
}


/////This is to handle the zooming in and Zoom out
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // double tap zooms in
	UIScrollView *imageScrollView ;//= [[UIScrollView  alloc] init];
	
	imageScrollView = (UIScrollView*)[arrayScroll objectAtIndex:_which_image];
	
    float newScale;
	//////Code to zoom in on double tapping
	if(imageScrollView.tag ==1)
	{
		newScale = [imageScrollView zoomScale] * ZOOM_STEP;
		[imageScrollView setTag:0];//////if scroll is zoom in tag of that scrollveiw is 0
	}
	
	//////Code to zoom Out on double tapping
	else 
	{
		//////if scroll is zoom out tag  of that scrollveiw is 1
	[imageScrollView setTag:1];
	newScale = [imageScrollView zoomScale] / ZOOM_STEP;
	}

	CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
	[imageScrollView zoomToRect:zoomRect animated:YES];
	
}
//////////////////////


//////navigation title of the navigation bar
-(void)navigationTitleSet:(NSInteger)index
{
	[self.navigationItem setTitle:[NSString stringWithFormat:@"Image%d",index]];
}
///////////////////////


#pragma mark -
#pragma mark viewForZoomingInScrollView

/////For the Zooming of the image by using the scrollview
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollview 
{
   	return (UIImageView*)[arrayImageView objectAtIndex:_which_image];
} 
////////Scrolling Action Control
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
	if(scrollView == scroll_View)
	{
	int page	=	floor((scrollView.contentOffset.x - 320/ 2) / 320) + 1;
		if(page<NUM)
		{
			[scroll_View setContentOffset:CGPointMake(page*320,0) animated:YES];
			_which_image = page;
			[self navigationTitleSet:page+1];
		}
	}
}

///////Save the image into the gallery
-(void)saveTheImageInGallery
{
	UIImage *Image = [UIImage imageNamed:[arrayImages objectAtIndex:_which_image]];
    UIImageWriteToSavedPhotosAlbum(Image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


#pragma mark -
#pragma mark presstoSave

/////////Action Sheet
-(IBAction)presstoSave:(id)sender
{
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Info" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Save To PhotoGallery",@"Locations",@"Email The Image",@"Capture New Photo",@"Cancel", nil];
    popupQuery.actionSheetStyle = UIBarStyleBlack;
    [popupQuery showInView:self.view];
	if(popupQuery)
	{
		[popupQuery release];
		popupQuery=nil;
	}	
}

/////////////////To show either image is saved or not
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
	UIAlertView *alert;
	if (error)
		alert = [[UIAlertView alloc] initWithTitle:@"Error" 
										   message:@"Unable to save image to Photo Album." 
										  delegate:self cancelButtonTitle:@"Ok" 
								 otherButtonTitles:nil];
	else // All is well
		alert = [[UIAlertView alloc] initWithTitle:@"Success" 
										   message:@"Image saved to Photo Album." 
										  delegate:self cancelButtonTitle:@"Ok" 
								 otherButtonTitles:nil];
	[alert show];
	
	if(alert)
	{
		[alert release];
		alert = nil;
	}
}
/////////////////////////////////
#pragma mark -
#pragma mark getPicture


- (void) getPicture 
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:picker animated:YES];
}

- (void) imagePickerController:(UIImagePickerController *)thePicker 
 didFinishPickingMediaWithInfo:(NSDictionary *)imageInfo
{
	static int scrllImage  =  NUM;
	scrllImage++;
    [thePicker dismissModalViewControllerAnimated:YES];
	UIImage *img = [imageInfo objectForKey:@"UIImagePickerControllerOriginalImage"];
	[scroll_View setContentSize: CGSizeMake(320*scrllImage+30, HEIGHT-10)];
    [self scrollViewZoom:img];
	
	locmanager = [[CLLocationManager alloc] init];
	[locmanager setDelegate:self];
	[locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
	NSLog(@"%f",locmanager.location.coordinate.latitude);
	[locmanager startUpdatingLocation];

}

#pragma mark -
#pragma mark didUpdateToLocation

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	// Log the kind of accuracy we got from this
	
	// Location has been found. Create GMap URL
	CLLocationCoordinate2D loc = [newLocation coordinate];
	[arrayLat addObject:[NSString stringWithFormat:@"%f",loc.latitude]];
	[arrayLong addObject:[NSString stringWithFormat:@"%f",loc.longitude]];
}


#pragma mark -
#pragma mark mailComposeController

//////////////////////////////////Mail compose controller 
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void) dismissHUD
{
	if (![ModalHUD dismiss])
		[self performSelector:@selector(dismissHUD) withObject:nil afterDelay:0.2f];
}


///////Email the Image(chunck of code for emailing the image)
-(void)emailTheImage:(UIImage*)imageToEmail
{
	if ([MFMailComposeViewController canSendMail])
	{
		MFMailComposeViewController *mcvc = [[[MFMailComposeViewController alloc] init] autorelease];
		mcvc.mailComposeDelegate = self;
		[mcvc setSubject:@"Here's a great photo!"];
		NSString *body = @"<h1>Check this out</h1><p>I selected this image for <code><b>YOU ONLY</b></code>.</p>";
		[mcvc setMessageBody:body isHTML:YES];
		[mcvc addAttachmentData:UIImageJPEGRepresentation(imageToEmail, 1.0f) mimeType:@"image/jpeg" fileName:@"pickerimage.jpg"];
		[self presentModalViewController:mcvc animated:YES];
		[self dismissHUD];
	}

}


//////////////////////////////Action Sheet action
#pragma mark -
#pragma mark actionSheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{	
		switch(buttonIndex) 
		{
			case 0:
				[self saveTheImageInGallery];
				break;
			case 1:
			{
				MapViewController *obj = [[MapViewController alloc] init];
				obj.arrayLat = arrayLat;
				obj.arrayLong = arrayLong;
				[self.navigationController pushViewController:obj animated:YES];
				[obj  release];
			}	
			break;

			case 2:
				[self emailTheImage:[UIImage imageNamed:[arrayImages objectAtIndex:_which_image]]];
			    break;
				
			case 3:
				[self getPicture];
				break;

			default:
				break;
		}
}
//////////////////////////////////////

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return NO;
}


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


- (void)dealloc
{
	[scroll_View release];
	[imageView release];
	[arrayScroll release];
	[arrayImages release];
	[arrayImageView release];
    [super dealloc];
}


@end
