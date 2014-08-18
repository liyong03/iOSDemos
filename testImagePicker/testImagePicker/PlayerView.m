//
//  PlayerView.m
//  testImagePicker
//
//  Created by Yong Li on 8/18/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "PlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVPlayer.h>

static const NSString *ItemStatusContext;

@implementation PlayerView {
    AVPlayer        *_player;
    AVPlayerItem    *_playerItem;
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayerLayer*)playerLayer {
    return (AVPlayerLayer*)self.layer;
}

- (void)playURL:(NSURL*)url {
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSString *tracksKey = @"tracks";
    
    [asset loadValuesAsynchronouslyForKeys:@[tracksKey] completionHandler:^{
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           NSError *error;
                           AVKeyValueStatus status = [asset statusOfValueForKey:tracksKey error:&error];
                           
                           if (status == AVKeyValueStatusLoaded) {
                               _playerItem = [AVPlayerItem playerItemWithAsset:asset];
                               // ensure that this is done before the playerItem is associated with the player
                               [_playerItem addObserver:self forKeyPath:@"status"
                                                options:NSKeyValueObservingOptionInitial
                                                context:&ItemStatusContext];
                               [[NSNotificationCenter defaultCenter] addObserver:self
                                                                        selector:@selector(playerItemDidReachEnd:)
                                                                            name:AVPlayerItemDidPlayToEndTimeNotification
                                                                          object:_playerItem];
                               _player = [AVPlayer playerWithPlayerItem:_playerItem];
                               [[self playerLayer] setPlayer:_player];
                           }
                           else {
                               // You should deal with the error appropriately.
                               NSLog(@"The asset's tracks were not loaded:\n%@", [error localizedDescription]);
                           }
                       });

    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    
    if (context == &ItemStatusContext) {
        if (_playerItem.status == AVPlayerItemStatusReadyToPlay) {
            [_playerItem removeObserver:self
                             forKeyPath:@"status"
                                context:&ItemStatusContext];
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [_player play];
                           });
        }
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object
                           change:change context:context];
    return;
}


- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [_player seekToTime:kCMTimeZero];
    [_player play];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    NSLog(@"remove");
}

@end
