//
//  QRHistory.m
//  QRQR
//
//  Created by Jeong YunWon on 13. 1. 22..
//  Copyright (c) 2013 3rddev.org. All rights reserved.
//

#import "QRHistory.h"

@implementation QRHistory

id QRHistoryDefaultObject = nil;

+ (void)initialize {
    if (self == [QRHistory class]) {
        QRHistoryDefaultObject = [[QRHistory alloc] init];
    }
}

+ (id)defaultHistory {
    return QRHistoryDefaultObject;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        self->_autosync = YES;
        self->_userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *history = [self->_userDefaults objectForKey:@"history"];
        if (history != nil) {
            self->_history = [[NSMutableArray alloc] initWithArray:history];
        } else {
            self->_history = [[NSMutableArray alloc] init];
        }
        NSArray *favorite = [self->_userDefaults objectForKey:@"favorite"];
        if (favorite != nil) {
            self->_favorites = [[NSMutableArray alloc] initWithArray:favorite];
        } else {
            self->_favorites = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)dealloc {
    [self->_history release];
    [self->_favorites release];
    [super dealloc];
}

- (void)put:(NSString *)item {
    if ([self->_history indexOfObject:item] != NSNotFound) {
        [self->_history removeObject:item];
    }
    NSUInteger index = [self->_favorites indexOfObject:item];
    if (index != NSNotFound) {
        [self->_favorites removeObjectAtIndex:index];
        [self->_favorites insertObject:item atIndex:0];
    } else {
        index = [self->_history indexOfObject:item];
        if (index != NSNotFound) {
            [self->_history removeObjectAtIndex:index];
        }
        [self->_history insertObject:item atIndex:0];
        if (self->_history.count > 100) {
            [self->_history removeLastObject];
        }
    }
    if (self->_autosync) {
        [self synchronize];
    }
}

- (void)favorite:(NSString *)item {
    [self->_history removeObject:item];
    [self->_favorites removeObject:item];
    [self->_favorites insertObject:item atIndex:0];
    if (self->_autosync) {
        [self synchronize];
    }
}

- (void)defavorite:(NSString *)item {
    [self->_history removeObject:item];
    [self->_favorites removeObject:item];
    [self->_history insertObject:item atIndex:0];
    if (self->_autosync) {
        [self synchronize];
    }
}

- (void)synchronize {
    [self->_userDefaults setObject:self->_history forKey:@"history"];
    [self->_userDefaults setObject:self->_favorites forKey:@"favorite"];
    [self->_userDefaults synchronize];
}


@end
