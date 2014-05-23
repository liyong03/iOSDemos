//
//  testViewController.m
//  testReactiveCocoa
//
//  Created by Yong Li on 3/24/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "testViewController.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import <UIControl+RACSignalSupport.h>
#import <AFNetworking.h>

@interface testViewController ()

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIButton* button;
@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, strong) UIProgressView* progressView;
@property (nonatomic, assign) float progress;

@end

@implementation testViewController {
    NSURLSessionDownloadTask* _downloadTask;
    NSData* _resumeData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *path = [self pathForResumeData];
    _resumeData = [NSData dataWithContentsOfFile:path];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 320, 240)];
    _imageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_imageView];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 320, 320, 40);
    [_button setTitle:@"Click" forState:UIControlStateNormal];
    [_button setTintColor:[UIColor redColor]];
    [_button setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:_button];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 320, 320, 10)];
    [self.view addSubview:_progressView];
    
    [[RACObserve(self, progress) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSNumber* number) {
        NSLog(@"ccc = %@", number);
        _progressView.progress = number.floatValue;
    }];
    
    @weakify(self);
    [[[self downloadImageWithURL:[NSURL URLWithString:@"http://d13yacurqjgara.cloudfront.net/users/306293/screenshots/1475496/___-1.jpg"]]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(UIImage* image) {
         @strongify(self);
         self.imageView.image = image;
     }
     error:^(NSError *error) {
         NSLog(@"error : %@", error);
     }];
    
    [self testMerge];
    
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 400, 320, 40);
    [btn setTitle:@"Start" forState:UIControlStateNormal];
    [btn setTintColor:[UIColor redColor]];
    [btn setBackgroundColor:[UIColor greenColor]];
    [btn addTarget:self action:@selector(downloadBigFile:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 450, 320, 40);
    [btn2 setTitle:@"pause" forState:UIControlStateNormal];
    [btn2 setTintColor:[UIColor redColor]];
    [btn2 setBackgroundColor:[UIColor greenColor]];
    [btn2 addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
}

- (NSString*)pathForResumeData {
    
    NSString *documentdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentdir stringByAppendingPathComponent:@"data.resume"];
    return path;
}

- (void)testMerge {
    RACSignal* sig1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            for (int i=0; i<100; i++) {
                [NSThread sleepForTimeInterval:0.1];
                NSLog(@"1 : %d", i);
                [subscriber sendNext:@(i)];
            }
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
    
    
    RACSignal* sig2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            for (int i=0; i<100; i++) {
                [NSThread sleepForTimeInterval:0.15];
                NSLog(@"2 : %d", i);
                [subscriber sendNext:@(i)];
            }
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
    
    [[[RACSignal merge:@[sig1, sig2]]
      doNext:^(NSNumber* x) {
          NSLog(@"--- %@", x);
      }]
     subscribeCompleted:^{
         NSLog(@"============= DONE =============");
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RACSignal*)downloadImageWithURL:(NSURL*)url {
    
    //
    //    NSError *error = [NSError errorWithDomain:@"Test"
    //                                         code:100
    //                                     userInfo:nil];
    self.progress = 0;
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSProgress *progress;
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request progress:&progress
                                                                      destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                          [subscriber sendNext:[UIImage imageWithData:[NSData dataWithContentsOfURL:targetPath]]];
                                                                          return nil;
                                                                      } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                          if(!error) {
                                                                              [subscriber sendCompleted];
                                                                          }
                                                                          else {
                                                                              [subscriber sendError:error];
                                                                          }
                                                                      }];
        
        [downloadTask resume];
        [session setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            self.progress = (float)totalBytesWritten/(float)totalBytesExpectedToWrite;
            NSLog(@"p = %f", self.progress);
        }];
        
        //            [progress addObserver:self
        //                       forKeyPath:@"fractionCompleted"
        //                          options:NSKeyValueObservingOptionNew
        //                          context:NULL];
        
        //            NSData* data = [NSData dataWithContentsOfURL:url];
        //            if(data) {
        //                [subscriber sendNext:[UIImage imageWithData:data]];
        //                [subscriber sendCompleted];
        //            }
        //            else {
        //                [subscriber sendError:error];
        //            }
        //});
        return nil;
    }];
}

- (void)downloadBigFile:(UIButton*)btn {
    if(!_resumeData ) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/MobileHIG.pdf"]];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSProgress *progress;
        _downloadTask = [session downloadTaskWithRequest:request progress:&progress
                                                                      destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                          return nil;
                                                                      } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                          NSLog(@"done");
                                                                      }];
        
        [_downloadTask resume];
        [session setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            float progress = (float)totalBytesWritten/(float)totalBytesExpectedToWrite;
            NSLog(@"p = %f", progress);
            self.progress = progress;
        }];
    } else {
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSProgress *progress;
        _downloadTask = [session downloadTaskWithResumeData:_resumeData
                                                   progress:&progress
                                                destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                    return nil;
                                                } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                    NSLog(@"resume done");
                                                }];
        [_downloadTask resume];
        [session setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            float progress = (float)totalBytesWritten/(float)totalBytesExpectedToWrite;
            NSLog(@"p = %f", progress);
            self.progress = progress;
        }];
    }
}

- (void)pause {
    if (_downloadTask) {
        [_downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            _resumeData = resumeData;
            NSString *path = [self pathForResumeData];
            [_resumeData writeToFile:path atomically:YES];
        }];
    }
}

@end
