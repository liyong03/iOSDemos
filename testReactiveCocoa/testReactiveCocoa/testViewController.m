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

@interface testViewController ()

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIButton* button;
@property (nonatomic, strong) UITextField* textField;

@end

@implementation testViewController {
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
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 240)];
    _imageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_imageView];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 450, 320, 40);
    [_button setTitle:@"Click" forState:UIControlStateNormal];
    [_button setTintColor:[UIColor redColor]];
    [_button setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:_button];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 500, 320, 30)];
    [self.view addSubview:_textField];
    
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
    
    
    NSError *error = [NSError errorWithDomain:@"Test"
                                         code:100
                                     userInfo:nil];
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData* data = [NSData dataWithContentsOfURL:url];
            if(data) {
                [subscriber sendNext:[UIImage imageWithData:data]];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendError:error];
            }
        });
        return nil;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
