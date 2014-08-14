//
//  ViewController.m
//  testImagePicker
//
//  Created by Yong Li on 8/13/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "CAAnimation+Blocks.h"

@interface YLCameraAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL isForward;
@end

@implementation YLCameraAnimation


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // 1. Get controllers from transition context
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    
    CGRect startFrame = [transitionContext initialFrameForViewController:fromVC];
    fromVC.view.frame = startFrame;
    
    // 2. Set init frame for toVC
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.frame = finalFrame;
    
    // 3. Add toVC's view to containerView
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];

    
    CABasicAnimation* basicScaleAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    basicScaleAnimation.duration = [self transitionDuration:transitionContext];
    basicScaleAnimation.beginTime = 0;
    basicScaleAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 100, 100)];
    basicScaleAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, finalFrame.size.width, finalFrame.size.height)];
    basicScaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basicScaleAnimation.fillMode = kCAFillModeForwards;
    basicScaleAnimation.removedOnCompletion = NO;
    [basicScaleAnimation setCompletion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
    }];
    
    toVC.view.layer.contentsGravity = kCAGravityResizeAspect;
    toVC.view.layer.masksToBounds = YES;
    toVC.view.layer.borderColor = [UIColor redColor].CGColor;
    toVC.view.layer.borderWidth = 5;
    [toVC.view.layer addAnimation:basicScaleAnimation forKey:@"Scale"];
    
}

@end


@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@end

@implementation ViewController {
    AVCaptureSession *captureSession;
    YLCameraAnimation* _animator;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _animator = [[YLCameraAnimation alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureSessionDidStopRunningNotification
                                                      object:nil queue:nil usingBlock:^(NSNotification *note) {
                                                          NSLog(@"note = %@", note);
                                                      }];
    
    
    captureSession = [[AVCaptureSession alloc] init];
    [captureSession setSessionPreset:AVCaptureSessionPreset352x288];
    NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice* dev in devices) {
        if ([dev hasMediaType:AVMediaTypeVideo] && dev.position == AVCaptureDevicePositionBack) {
            NSError *error = nil;
            AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:dev error:&error];
            if (videoInput) {
                [captureSession addInput:videoInput];
                AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                previewLayer.frame = self.button.bounds; // Assume you want the preview layer to fill the view.
                [self.button.layer insertSublayer:previewLayer below:self.button.imageView.layer];
                [captureSession startRunning];
            }
            else {
                // Handle the failure.
            }
            break;
        }
    }
    
    
//    imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.delegate = self;
//    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    imagePicker.showsCameraControls = NO;
//    [self.button insertSubview:imagePicker.view belowSubview:self.button.imageView];
//    imagePicker.view.frame = self.button.bounds;
//    imagePicker.view.userInteractionEnabled = NO;
//    [imagePicker viewWillAppear:YES]; // trickery to make it show
//    [imagePicker viewDidAppear:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [captureSession startRunning];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [captureSession stopRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openImagePicker:(id)sender {
    
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = @[((__bridge NSString*)kUTTypeImage),((__bridge NSString*)kUTTypeMovie)];
    imagePicker.allowsEditing = YES;
    imagePicker.videoMaximumDuration = 60;
    //imagePicker.transitioningDelegate = self;
    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionReveal;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self presentViewController:imagePicker animated:YES completion:^{
    }];
    
//    CGRect frame = [self.view convertRect:imagePicker.view.frame fromView:self.button];
//    [imagePicker.view removeFromSuperview];
//    [self.view addSubview:imagePicker.view];
//    imagePicker.view.frame = frame;
//    imagePicker.showsCameraControls = YES;
//    imagePicker.view.userInteractionEnabled = YES;
//    [UIView animateWithDuration:5.0f
//                     animations:^{
//                         imagePicker.view.frame = self.view.bounds;
//                     } completion:^(BOOL finished) {
//                         //[imagePicker.view removeFromSuperview];
//                         //imagePicker.showsCameraControls = YES;
//                         [self presentViewController:imagePicker animated:NO completion:nil];
//                     }];
    
}

#pragma mark - ImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        //imagePicker.showsCameraControls = NO;
//        [self.button insertSubview:imagePicker.view belowSubview:self.button.imageView];
//        imagePicker.view.frame = self.button.bounds;
//        imagePicker.view.userInteractionEnabled = NO;
    }];
}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return _animator;
}

//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
//    return nil;
//}


@end
