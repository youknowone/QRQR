//
//  QRViewController.m
//  QRQR
//
//  Created by Jeong YunWon on 11. 3. 2..
//  Copyright 2011 youknowone.org. All rights reserved.
//

#import "QRViewController.h"
#import "QRCodeReader.h"

@implementation QRViewController
@synthesize qrResult;

- (void)initAsQRViewController {
    needScanning = YES;        
    widgetController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:NO OneDMode:NO showLicense:YES];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc] initWithObjects:qrcodeReader, nil];
    [qrcodeReader release];
    widgetController.readers = readers;
    [readers release];
    NSBundle *mainBundle = [NSBundle mainBundle];
    widgetController.soundToPlay = [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
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

- (void) presentScanViewController {
    [self presentModalViewController:widgetController animated:NO];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    resultTextView.text = qrResult;
    if (needScanning) {
        [self presentScanViewController];
        needScanning = NO;
    }
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark ZXingDelegate

- (void) zxingControllerDidCancel:(ZXingWidgetController *)controller {
	
}

- (void) zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result {
	self.qrResult = result;
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"Select Action", @"qrqr", @"Menu selection title") delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"common", @"") destructiveButtonTitle:NSLocalizedStringFromTable(@"Open with Safari", @"qrqr", @"Menu selection name") otherButtonTitles:NSLocalizedStringFromTable(@"Copy to Clipboard", @"qrqr", @"Menu selection name"), nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
    
    [controller dismissModalViewControllerAnimated:NO];
}

#pragma mark UIActionSheet delegate

- (void) actionSheetCancel:(UIActionSheet *)actionSheet {
	//[self 
}

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:resultTextView.text]];
            break;
		case 1:
            [UIPasteboard generalPasteboard].string = qrResult;
            break;
		default:
			break;
	}
    [self presentScanViewController];
}

@end

