//
//  main.m
//  QRQR
//
//  Created by Jeong YunWon on 11. 3. 2..
//  Copyright 2011 youknowone.org. All rights reserved.
//

#import <UI7Kit/UI7Kit.h>

int main(int argc, char *argv[]) {
    @autoreleasepool {
        [UI7Kit patchIfNeeded];
        return UIApplicationMain(argc, argv, nil, @"QRAppDelegate");
    }
}
