//
//  ViewController.m
//  DebuggingOverlayDemo
//
//  Created by shaolie on 2017/6/5.
//  Copyright © 2017年 shaolie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _signInBtn.layer.borderColor = [UIColor colorWithRed:124/255.0 green:218/255.0 blue:255/255.0 alpha:1].CGColor;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
