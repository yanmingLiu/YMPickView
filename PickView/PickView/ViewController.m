//
//  ViewController.m
//  PickView
//
//  Created by yons on 17/1/12.
//  Copyright © 2017年 yons. All rights reserved.
//

#import "ViewController.h"

#import "pickerControl.h"

#import "YMPickView.h"

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

- (IBAction)YMPickView:(id)sender {
    
    NSArray *arr = @[@[@"哈哈",@"哈哈",@"哈哈",@"哈哈"],@[@"哈哈",@"哈哈",@"哈哈",@"哈哈"],@[@"哈哈",@"哈哈",@"哈哈",@"哈哈"]];
    YMPickView *pickView = [[YMPickView alloc] initWithTitle:@"哈哈" DataSource:arr withSelectedItem:nil withSelectedBlock:^(id  _Nonnull item) {
        
        NSLog(@"%@", (NSString *)item);
    }];
    
    [pickView show];
}

- (IBAction)pickControl_time:(id)sender {
    pickerControl *pickView = [[pickerControl alloc] initWithType:1 columuns:3 WithDataSource:nil response:^(NSString *str) {
        NSLog(@"%@", str);
    }];
    [pickView show];
}

- (IBAction)pickControl_custom:(id)sender {
    NSArray *arr = @[@"哈哈",@"哈哈",@"哈哈",@"哈哈"];
    pickerControl *pickView = [[pickerControl alloc] initWithType:0 columuns:1 WithDataSource:arr response:^(NSString *str) {
        NSLog(@"%@", str);
    }];
    [pickView show];
}

@end
