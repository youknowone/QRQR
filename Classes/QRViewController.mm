//
//  QRViewController.m
//  QRQR
//
//  Created by Jeong YunWon on 11. 3. 2..
//  Copyright 2011 youknowone.org. All rights reserved.
//

#import "QRViewController.h"
#import "QRCodeReader.h"
#import "QRHistory.h"
#import "QRHistoryViewController.h"

#import "AdMobHelper.h"

@implementation QRViewController
@synthesize decodedString=_decodedString;

- (void)initAsQRViewController {
    self->_needsScanning = YES;
    widgetController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:NO OneDMode:NO showLicense:YES];

    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc] initWithObjects:qrcodeReader, nil];
    [qrcodeReader release];
    widgetController.readers = readers;
    [readers release];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    widgetController.soundToPlay = [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];

    self->historyButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    [self->historyButton setTitle:@"History" forState:UIControlStateNormal];
    [self->historyButton addTarget:self action:@selector(presentHistory) forControlEvents:UIControlEventTouchUpInside];
    self->historyButton.frame = CGRectMake(.0, .0, 80.0, 28.0);
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self initAsQRViewController];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self initAsQRViewController];
    return self;
}

- (void)dealloc {
    [self->widgetController release];
    [self->historyButton release];
    [super dealloc];
}

- (void)presentScanViewController {
    [self presentModalViewController:widgetController animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self->bannerView = [[UIView alloc] initWithFrame:CGRectMake(.0, .0, 320.0, 50.0)];
    self->bannerView.backgroundColor = [UIColor whiteColor];
    [self->widgetController.overlayView addSubview:self->bannerView];
    AdMobQuickSet(@"a150ffb66fc484c", self, self->bannerView);

    if (!self->historyButton.superview) {
        self->historyButton.center = CGPointMake(48.0, widgetController.overlayView.frame.size.height - 20.0);
        [widgetController.overlayView addSubview:self->historyButton];
    }
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    resultTextView.text = self.decodedString;
    if (self->_needsScanning) {
        [self presentScanViewController];
        self->_needsScanning = NO;
        #if DEBUG
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self zxingController:widgetController didScanResult:@"The world simplest QR code decoder!"];
        });
        #endif
    }
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)presentHistory {
    [self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:self->historyController animated:YES];
}

- (void)dismissHistory {
    [self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:widgetController animated:YES];
}

#pragma mark ZXingDelegate

- (void) zxingControllerDidCancel:(ZXingWidgetController *)controller {
	
}

- (void) zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result {
	self.decodedString = result;
    [[QRHistory defaultHistory] put:result];
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"Select Action", @"qrqr", @"Menu selection title") delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"common", @"") destructiveButtonTitle:NSLocalizedStringFromTable(@"Open with Safari", @"qrqr", @"Menu selection name") otherButtonTitles:NSLocalizedStringFromTable(@"Copy to Clipboard", @"qrqr", @"Menu selection name"), nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
    
    [controller dismissModalViewControllerAnimated:NO];
}

#pragma mark UIActionSheet delegate

- (void) actionSheetCancel:(UIActionSheet *)actionSheet {

}

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
            [[UIApplication sharedApplication] openURL:self.decodedString.URL];
            break;
		case 1:
            [UIPasteboard generalPasteboard].string = self.decodedString;
            break;
		default:
			break;
	}
    [self presentScanViewController];
}

@end

