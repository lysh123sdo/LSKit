//
//  LSKitDemoTests.swift
//  LSKitDemoTests
//
//  Created by Lyson on 2019/3/2.
//  Copyright © 2019年 LSKitDemo. All rights reserved.
//

import XCTest
import LSKit

class TestModel: NSObject,LSMQTopicReceiveProtocol {
    
    func topicReceive(_ msg: Any!, topic: String!) {
        
        print("其他类收到消息")
        print("\(topic!):\(msg!)")
        
    }
    deinit {
        print(self.description)
        print("释放了")
    }
}


class LSKitDemoTests: XCTestCase ,LSMQTopicReceiveProtocol{

    override func setUp() {
        
        let model = TestModel()
        LSMQMessageListManager.shareInstance()?.addTopic(model, topic: "testTopic")
       
    }
    
    func topicReceive(_ msg: Any!, topic: String!) {
    
        print("\(topic!):\(msg!)")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testMQ(){
        
        let model = TestModel()
        LSMQMessageListManager.shareInstance()?.addMsg(model, topic: "testTopic")
    }

}
