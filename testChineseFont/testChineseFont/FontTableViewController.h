//
//  FontTableViewController.h
//  testChineseFont
//
//  Created by Yong Li on 7/4/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^selectDontBlock)(NSString* fontName);

@interface FontTableViewController : UITableViewController
@property(nonatomic, copy) selectDontBlock dontBlock;
+ (void)showFontSelectionViewController:(selectDontBlock)dontblock;
@end
