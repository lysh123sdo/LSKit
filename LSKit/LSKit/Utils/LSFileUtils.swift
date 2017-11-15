//
//  LSFileUtils.swift
//  LSKit
//
//  Created by Lyson on 2017/11/13.
//  Copyright © 2017年 LSKit. All rights reserved.
//

import UIKit

class LSFileUtils: NSObject {

    /*从工程目录中获取文件路径*/
    static func filePathFromProj(fileName:String) -> String{
      
        let path:String! = Bundle.main.path(forResource: fileName, ofType: nil);

        if path == Optional.none {
            
            return "";
        }
        
        return path;
    }
    
    /*从工程目录中获取文件路径*/
    static func filePathFromProj(fileName:String , bundle:String) -> String{
    
        let path:String! = Bundle.main.path(forResource: fileName, ofType: nil, inDirectory: bundle);
        
        if path == Optional.none {
            
            return "";
        }
        
        return path;
    }
    
    /**从document中获取一个文件路径**/
    static func filePathFromSandBox(fileName:String) -> String{
       
        let path:String = NSHomeDirectory() + "/Documents/" + fileName;
        
        if path == Optional.none {
            
            return "";
        }
        
        return path;
    }
    
    /*在cache目录下创建一个目录 并返回一个路径*/
    static func createFileFolderInCacheSandBox(folder:String) -> String{

        var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true);
        
        let documentDic:String = paths[0];
        
        let path:String = documentDic + "/" + folder;
        
        if !FileManager.default.fileExists(atPath: path){
            
            let url:URL! = URL.init(fileURLWithPath: path);
            
            do{
                
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil);
                
            }catch {
                
                return ""
            }
            
        }
     
        return path;
    }
    
    /*获取一个cache中的目录 如目录不存在 则自动创建目录*/
    static func filePathFromCacheInSandBox(folder:String , fileName:String) -> String{
        
        let path:String = createFileFolderInCacheSandBox(folder: folder) + "/" + fileName;
        
        return path;
    }
    
}
