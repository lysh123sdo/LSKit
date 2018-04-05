//
//  ViewController.m
//  LSKitDemo
//
//  Created by Lyson on 2018/4/5.
//  Copyright © 2018年 LSKitDemo. All rights reserved.
//

#import "ViewController.h"

#import <LSKit/LSKit.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[LSMQMessageListManager shareInstance] addTopic:(id<LSMQTopicReceiveProtocol>)self topic:@"test"];
    
    
    [[LSMQMessageListManager shareInstance] addMsg:@"测试" topic:@"test"];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)topicReceive:(id)msg topic:(NSString*)topic{
    
    NSLog(@"@@@@@@@@ %@",topic);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
