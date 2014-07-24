//
//  ViewController.m
//  testAlerController
//
//  Created by Yong Li on 7/24/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
            
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)showAlert:(id)sender {
  
//  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"msg" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//  [alert show];
  
  UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"controller title" message:@"controller message" preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [alertController dismissViewControllerAnimated:YES completion:nil];
  }];
  UIAlertAction* cancel= [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    [alertController dismissViewControllerAnimated:YES completion:nil];
  }];
  [alertController addAction:ok];
  [alertController addAction:cancel];
  [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)showActionSheet:(id)sender {
  
  
  UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [alertController dismissViewControllerAnimated:YES completion:nil];
  }];
  UIAlertAction* cancel= [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    [alertController dismissViewControllerAnimated:YES completion:nil];
  }];
  
  UIAlertAction* destructive= [UIAlertAction actionWithTitle:@"Destructive" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    [alertController dismissViewControllerAnimated:YES completion:nil];
  }];
  [alertController addAction:ok];
  [alertController addAction:cancel];
  [alertController addAction:destructive];
  [self presentViewController:alertController animated:YES completion:nil];
}
@end
