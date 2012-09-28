//
//  QRViewController.h
//  QRQR
//
//  Created by Jeong YunWon on 11. 3. 2..
//  Copyright 2011 youknowone.org. All rights reserved.
//

#import "ZXingWidgetController.h"

@class QRWebViewController;

@interface QRViewController : UIViewController<ZXingDelegate, UIActionSheetDelegate> {
    IBOutlet QRWebViewController *webViewController;

    IBOutlet UITextView *resultTextView;
    ZXingWidgetController *widgetController;

    NSString *qrResult;
    BOOL needScanning;
}

@property(nonatomic, retain) NSString *qrResult;

@end

