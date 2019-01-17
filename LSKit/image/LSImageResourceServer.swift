//
//  LSLabelServerSwift.swift
//  GWBaseLib
//
//  Created by Lyson on 2019/1/10.
//

import UIKit


public func LSImageSwift(name:String,module:String,file:String = #file) -> UIImage{
    

    let value = LSImageResourceServer.imageNameSwift(name, moduleName: module, file: file)
    
    return value
}

//[LSImageResourceServer imageName:name moduleName:module file:__FILE__]

