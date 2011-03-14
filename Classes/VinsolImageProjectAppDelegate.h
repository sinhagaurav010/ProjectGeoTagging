//
//  VinsolImageProjectAppDelegate.h
//  VinsolImageProject
//
//  Created by gaurav sinha on 02/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VinsolImageProjectAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	IBOutlet UINavigationController *navigation;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

