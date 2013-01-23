//
//  QRHistoryViewController.m
//  QRQR
//
//  Created by Jeong YunWon on 13. 1. 21..
//  Copyright (c) 2013년 3rddev.org. All rights reserved.
//

#import "QRHistory.h"
#import "QRHistoryViewController.h"

@implementation QRHistoryViewController

UIImage *QRHistoryViewControllerFavoriteLightImage = nil;
UIImage *QRHistoryViewControllerFavoriteDarkImage = nil;

+ (void)initialize {
    if (self == [QRHistoryViewController class]) {
        QRHistoryViewControllerFavoriteLightImage = [[UIImage imageNamed:@"favorite.png"] retain];
        QRHistoryViewControllerFavoriteDarkImage = [[UIImage imageNamed:@"favorite-dark.png"] retain];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationBar.topItem.rightBarButtonItem = self->_tableViewController.editButtonItem;
    [self->_tableViewController.tableView reloadData];
}

- (void)favorite:(UIButton *)sender {
    QRHistory *history = [QRHistory defaultHistory];
    [history favorite:[history.history objectAtIndex:sender.tag]];
    [self->_tableViewController.tableView reloadData];
}

- (void)defavorite:(UIButton *)sender {
    QRHistory *history = [QRHistory defaultHistory];
    [history defavorite:[history.favorites objectAtIndex:sender.tag]];
    [self->_tableViewController.tableView reloadData];
}

#pragma mark table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QRHistory *history = [QRHistory defaultHistory];
    switch (section) {
        case 0:
            return history.favorites.count;
            break;
        case 1:
            return history.history.count;
            break;
        default:
            dassert(NO);
            break;
    }
    dassert(NO);
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QRHistory *history = [QRHistory defaultHistory];
    NSString *cellIdentifier = nil;
    switch (indexPath.section) {
        case 0: {
            cellIdentifier = @"favorite";
        }   break;
        case 1: {
            cellIdentifier = @"history";
        }   break;
        default:
            dassert(NO);
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [UITableViewCell cellWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIButton *accesssory = [UIButton buttonWithType:UIButtonTypeCustom];
        accesssory.frame = CGRectMake(.0, .0, 36.0, 36.0);
        cell.accessoryView = accesssory;
        if (indexPath.section == 0) {
            [accesssory setImage:QRHistoryViewControllerFavoriteLightImage forState:UIControlStateNormal];
            [accesssory addTarget:self action:@selector(defavorite:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [accesssory setImage:QRHistoryViewControllerFavoriteDarkImage forState:UIControlStateNormal];
            [accesssory addTarget:self action:@selector(favorite:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = [history.favorites objectAtIndex:indexPath.row];
        }   break;
        case 1: {
            cell.textLabel.text = [history.history objectAtIndex:indexPath.row];
        }   break;
        default: {
            dassert(NO);
        }   break;
    }
    cell.accessoryView.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QRHistory *history = [QRHistory defaultHistory];
    NSArray *pool = indexPath.section == 0 ? history.favorites : history.history;
    self.lastSelectedString = [pool objectAtIndex:indexPath.row];

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"Select Action", @"qrqr", @"Menu selection title")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"common", @"")
                                               destructiveButtonTitle:NSLocalizedStringFromTable(@"Open with Safari", @"qrqr", @"Menu selection name")
                                                    otherButtonTitles:NSLocalizedStringFromTable(@"Copy to Clipboard", @"qrqr", @"Menu selection name"), nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    QRHistory *history = [QRHistory defaultHistory];
    switch (section) {
        case 0:
            if (history.favorites.count == 0) {
                return nil;
            }
            return @"Favorites";
            break;
        case 1:
            return @"History";
            break;
        default:
            break;
    }
    dassert(NO);
    return nil;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (destinationIndexPath.section == 1) {
        [tableView reloadData];
        return;
    }
    QRHistory *history = [QRHistory defaultHistory];
    [history.favorites moveObjectAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    QRHistory *history = [QRHistory defaultHistory];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        switch (indexPath.section) {
            case 0: {
                [history.favorites removeObjectAtIndex:indexPath.row];
            }   break;
            case 1: {
                [history.history removeObjectAtIndex:indexPath.row];
            }   break;
            default:
                dassert(NO);
                break;
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [history synchronize];
    }
}

#pragma mark UIActionSheet delegate

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {

}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
            [[UIApplication sharedApplication] openURL:self.lastSelectedString.URL];
            break;
		case 1:
            [UIPasteboard generalPasteboard].string = self.lastSelectedString;
            break;
		default:
			break;
	}
}

@end
