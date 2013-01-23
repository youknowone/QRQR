//
//  QRViewController.h
//  QRQR
//
//  Created by Jeong YunWon on 11. 3. 2..
//  Copyright 2011 youknowone.org. All rights reserved.
//

#import "ZXingWidgetController.h"

@class QRWebViewController;
@class QRHistoryViewController;

@interface QRViewController : UIViewController<ZXingDelegate, UIActionSheetDelegate> {
    IBOutlet QRWebViewController *webViewController;

    IBOutlet UITextView *resultTextView;
    ZXingWidgetController *widgetController;
    UIButton *historyButton;

    IBOutlet QRHistoryViewController *historyController;

    NSString *_decodedString;
    BOOL _needsScanning;
}

@property(nonatomic, retain) NSString *decodedString;

- (IBAction)presentHistory;
- (IBAction)dismissHistory;

@end

