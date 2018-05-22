//
//  TestViewController.m
//  LSKitDemo
//
//  Created by Lyson on 2018/5/22.
//  Copyright © 2018年 LSKitDemo. All rights reserved.
//

#import "TestViewController.h"
#import <LSKit/LSKit.h>

@interface TestViewController ()

@end

@implementation TestViewController


-(instancetype)initWithRouterParams:(NSDictionary*)paramter{
    
    if (self = [super init]) {
        
        NSLog(@"收到参数 %@",paramter);
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 70, 100, 100)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    // Do any additional setup after loading the view.
}

-(void)btnClick{
    
    [[LSRouter sharedRouter] pop:YES format:@"TestViewController" extraParams:@{@"key":@"callback"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)dealloc{
    
    
}

@end

