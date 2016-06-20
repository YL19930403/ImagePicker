//
//  AppDelegate.swift
//  ImagePicker
//
//  Created by 余亮 on 16/6/20.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame:UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = PictureSelectVC()
        window?.makeKeyAndVisible()
        return true
    }
}


func YLLog<T>(message:T, file:NSString = __FILE__ , method:String = __FUNCTION__,line : Int = __LINE__ )
{
    #if DEBUG
        print("\(method)[\(line)]: \(message)")
    #endif
}
