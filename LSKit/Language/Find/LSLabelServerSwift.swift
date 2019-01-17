//
//  LSLabelServerSwift.swift
//  GWBaseLib
//
//  Created by Lyson on 2019/1/10.
//

import UIKit

class LSLabelServerSwift: NSObject {

}

public func LSTextSwift(key:String,defaultValue:String) -> String{
    
    let value = LSTextFind.findKeyText([key,defaultValue], language: LSTextFind.currentLanguage())
    
    return value!
}



