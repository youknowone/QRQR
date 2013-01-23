//
//  QRHistoryViewController.h
//  QRQR
//
//  Created by Jeong YunWon on 13. 1. 21..
//  Copyright (c) 2013년 3rddev.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRHistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
    IBOutlet UITableViewController *_tableViewController;
    IBOutlet UIView *bannerView;
}

@property(nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property(nonatomic, retain) NSString *lastSelectedString;

@end
