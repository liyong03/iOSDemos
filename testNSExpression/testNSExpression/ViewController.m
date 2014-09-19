//
//  ViewController.m
//  testNSExpression
//
//  Created by Yong Li on 14-9-19.
//  Copyright (c) 2014年 Yong Li. All rights reserved.
//

#import "ViewController.h"

@interface NSNumber (Factorial)

- (NSNumber *)factorial;

@end

@implementation NSNumber (Factorial)

- (NSNumber *)factorial {
    return @(tgamma([self doubleValue] + 1));
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSExpression* exp = [NSExpression expressionWithFormat:@"2**-1"];
    NSLog(@"result = %@", [exp expressionValueWithObject:nil context:nil]);
    
    NSArray *numbers = @[@1, @2, @3, @4, @4, @5, @9, @11];
    NSExpression *expression = [NSExpression expressionForFunction:@"sum:" arguments:@[[NSExpression expressionForConstantValue:numbers]]];
    NSLog(@"result = %@", [expression expressionValueWithObject:nil context:nil]);
    
    expression = [NSExpression expressionWithFormat:@"FUNCTION(4.2, 'factorial')"];
    NSLog(@"result = %@", [expression expressionValueWithObject:nil context:nil]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
