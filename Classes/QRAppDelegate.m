//
//  QRAppDelegate.m
//  QRQR
//
//  Created by Jeong YunWon on 11. 3. 2..
//  Copyright 2011 youknowone.org. All rights reserved.
//

#import "QRAppDelegate.h"
#import "QRViewController.h"

@implementation QRAppDelegate

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    self.window = nil;
    [super dealloc];
}


@end
