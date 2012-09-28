//
//  QRAppDelegate.h
//  QRQR
//
//  Created by Jeong YunWon on 11. 3. 2..
//  Copyright 2011 youknowone.org. All rights reserved.
//

@class QRViewController;

@interface QRAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UINavigationController *navigationController;
    IBOutlet QRViewController *viewController;
}

@property(nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic, retain) IBOutlet UIView *bannerView;

@end

