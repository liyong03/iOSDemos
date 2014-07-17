//
//  TapEffectView.h
//  viewTapEffectDemo
//
//  Created by Yong Li on 7/16/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapEffectView : UIView
- (void)showEffectWithCompletion:(void(^)())handler;
- (void)showEnlargeEffect;
- (void)dismissEnlargeEffect:(void(^)())handler;
@end
