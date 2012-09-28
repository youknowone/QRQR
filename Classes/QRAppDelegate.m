//
//  QRAppDelegate.m
//  QRQR
//
//  Created by Jeong YunWon on 11. 3. 2..
//  Copyright 2011 youknowone.org. All rights reserved.
//

#import "CaulyHelper.h"
#import "QRAppDelegate.h"
#import "QRViewController.h"

@implementation QRAppDelegate

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Add the view controller's view to the window and display.
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];

//    CaulyGlobalSet(@"CAULY", navigationController, self.bannerView, nil);
//    [self.window bringSubviewToFront:self.bannerView];
    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
    self.window = nil;
    [super dealloc];
}


@end
