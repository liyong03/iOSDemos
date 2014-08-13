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

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ViewController {
    AVCaptureSession *captureSession;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark - ImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
