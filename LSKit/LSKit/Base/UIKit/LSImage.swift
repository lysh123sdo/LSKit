//
//  LSImage.swift
//  LSKit
//
//  Created by Lyson on 2017/11/14.
//  Copyright © 2017年 LSKit. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics
import QuartzCore


extension UIImage {
    
    /**绘制圆角图片*/
    func imageWithRoudedByRadiu(radiu:CGFloat) -> UIImage {
        
        let image:UIImage = imageWithRoudedByRadiu(radiu: radiu, borderWith: 0);
        
        return image;
    }
    
    /**绘制圆角图片*/
    func imageWithRoudedByRadiu(radiu:CGFloat , borderWith:CGFloat) -> UIImage {
        
        let image:UIImage = imageWithRadiu(radiu: radiu, corners: UIRectCorner.allCorners, borderWidth: borderWith);
        
        return image;
    }
    
    /**绘制圆角图片*/
    func imageWithRadiu(radiu:CGFloat , corners:UIRectCorner , borderWidth:CGFloat) -> UIImage{
        
        let width:Int! = self.cgImage?.width;
        let height:Int! = self.cgImage?.height;
        let newRect:CGRect = CGRect.init(x: 0, y: 0, width: width, height: height);
       
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let context:CGContext! = UIGraphicsGetCurrentContext();
        
        let bezPath:UIBezierPath = UIBezierPath.init(roundedRect: newRect, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radiu, height: borderWidth));
        bezPath.close();
        context.addPath(bezPath.cgPath);
        context.clip();

        context.draw(self.cgImage!, in: newRect);
        
        let newimage:CGImage = context.makeImage()!;
        
        context.strokePath();
        UIGraphicsEndImageContext();
        
        return UIImage.init(cgImage: newimage);
    }
    
    
    
}
