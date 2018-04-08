# LSKit
Swift Utils Kit

####组件化消息通信:LSMQMessageListManager消息队列管理

>添加消息监听

[[LSMQMessageListManager shareInstance] addTopic:(id)self topic:@"testwTopic"];

>添加消息

[[LSMQMessageListManager shareInstance] addMsg:text topic:@"testwTopic"];

>消息回调

-(void)topicReceive:(id)msg topic:(NSString*)topic


>###使用方式

pod 'LSKit'
