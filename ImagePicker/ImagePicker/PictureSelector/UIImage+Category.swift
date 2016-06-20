//
//  UIImage+Category.swift
//  ImagePicker
//
//  Created by 余亮 on 16/6/20.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit

extension UIImage {
    /**
        根据传入的宽度生成一张图片， 按照图片的宽度来压缩以前的图片
     */
    func imageWithScale(width : CGFloat) -> UIImage {
        //1.根据宽度计算高度
        let height = width * (size.height / size.width)
        //2.按照宽高比绘制一张新的图片
        let currentSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(currentSize)
        drawInRect(CGRect(origin: CGPointZero, size: currentSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
        
    }
    
}































