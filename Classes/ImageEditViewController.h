//
//  ImageEditViewController.h
//  ImageEditing
//
//  Created by gaurav sinha on 15/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ModalHUD.h"
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CoreLocation.h>

#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]


@interface ImageEditViewController : UIViewController <UIScrollViewDelegate,CLLocationManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UIGestureRecognizerDelegate>{
	IBOutlet  UIScrollView *scroll_View;
	UIImageView		*imageView;
	NSMutableArray  *arrayScroll;
	NSInteger		_which_image;
	NSMutableArray *arrayImages;
	CGPoint		   currentPosition;
 	NSMutableArray *arrayImageView;
	
	NSMutableArray *arrayLat;
	NSMutableArray *arrayLong;
	BOOL _Zoomin;
	
	CLLocationManager *locmanager;
	UITapGestureRecognizer *tapRecognizer;
}
-(void)navigationTitleSet:(NSInteger)index;
-(void)scrollViewZoom:(UIImage*)image;
@property (nonatomic, retain) 	IBOutlet  UIScrollView *scroll_View;
@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;

@end
