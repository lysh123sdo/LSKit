//
//  LSColor.swift
//  LSKit
//
//  Created by Lyson on 2017/11/13.
//  Copyright © 2017年 LSKit. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    /*16进制字符串转换成颜色*/
    static func colorWithHex(hexStr:String) -> UIColor {
        
        var colorStr:String!;
        
        if hexStr.isEmpty{
        
            return UIColor.init();
            
        }else if hexStr.hasPrefix("#"){
            
            colorStr = String.init(hexStr.dropFirst());
            
        }else if hexStr.hasPrefix("0x"){
          
            colorStr = String.init(hexStr.dropFirst(2));
        }
      
        let rStr:String = String.init(colorStr.prefix(2));
        let gStr:String = String.init(colorStr.prefix(4).dropFirst(2));
        let bStr:String = String.init(colorStr.dropFirst(4));
        
        var r:CUnsignedInt = 0;
        var g:CUnsignedInt = 0 ;
        var b:CUnsignedInt = 0;

        Scanner.init(string: rStr).scanHexInt32(&r);
        Scanner.init(string: gStr).scanHexInt32(&g);
        Scanner.init(string: bStr).scanHexInt32(&b);
        
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue:CGFloat(b)/255.0, alpha: 1);
    }
    
    /*16进制字符串转换成颜色 带透明度*/
    static func colorWithHex(hexStr:String , alph:CGFloat) -> UIColor {
        
        var colorStr:String!;
        
        if hexStr.isEmpty{
            
            return UIColor.init();
            
        }else if hexStr.hasPrefix("#"){
            colorStr = String.init(hexStr.dropFirst());
            
        }else if hexStr.hasPrefix("0x"){
            
            colorStr = String.init(hexStr.dropFirst(2));
        }
        
        let rStr:String = String.init(colorStr.prefix(2));
        let gStr:String = String.init(colorStr.prefix(4).dropFirst(2));
        let bStr:String = String.init(colorStr.dropFirst(4));
        
        var r:CUnsignedInt = 0;
        var g:CUnsignedInt = 0 ;
        var b:CUnsignedInt = 0;
        
        Scanner.init(string: rStr).scanHexInt32(&r);
        Scanner.init(string: gStr).scanHexInt32(&g);
        Scanner.init(string: bStr).scanHexInt32(&b);
        
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue:CGFloat(b)/255.0, alpha: alph);
    }

}
