//
//  QRHistory.h
//  QRQR
//
//  Created by Jeong YunWon on 13. 1. 22..
//  Copyright (c) 2013 3rddev.org. All rights reserved.
//

@interface QRHistory : NSObject {
    NSUserDefaults *_userDefaults;
}

@property(nonatomic, readonly) NSMutableArray *history, *favorites;
@property(nonatomic, assign, getter=isAutosync) BOOL autosync;

+ (id)defaultHistory;

- (void)put:(NSString *)item;
- (void)favorite:(NSString *)item;
- (void)defavorite:(NSString *)item;
- (void)synchronize;

@end
