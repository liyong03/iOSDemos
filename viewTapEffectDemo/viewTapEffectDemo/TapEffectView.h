//
//  TapEffectView.h
//  viewTapEffectDemo
//
//  Created by Yong Li on 7/16/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TapEffectState) {
    TapEffectUnopen = 0,
    TapEffectOpened,
};

@interface TapEffectView : UIView

@property (nonatomic, assign, readonly) TapEffectState state;

- (id)initWithShareIcons:(NSArray*)icons andTitles:(NSArray*)titles;

- (void)showEffectWithCompletion:(void(^)())handler;
- (void)showEnlargeEffect;
- (void)dismissEnlargeEffect:(void(^)())handler;
- (void)showCircleEffectWithCompletion:(void(^)())handler;

@end
