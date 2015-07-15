//
//  AppDelegate.swift
//  LNSwift(3)
//
//  Created by ccyy on 15/7/15.
//  Copyright (c) 2015年 111. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //创建一个window
        self.window = UIWindow( )
        self.window?.frame = UIScreen.mainScreen().bounds
        self.window?.makeKeyAndVisible()
        
        //创建三个视图控制器
        var first = FirstViewController()
        var second = SecondViewController()
        var third = ThirdViewController()
        
        //创建两个导航控制器
        var firstNav = UINavigationController(rootViewController: first)
        var secondNav = UINavigationController(rootViewController: second)
        
        //设置tabBar的item
        first.title = "第一"
        second.title = "第二"
        third.title = "第三"
        firstNav.tabBarItem.image = UIImage(named: "meishi")
        secondNav.tabBarItem.image = UIImage(named: "tuijian")
        third.tabBarItem.image = UIImage(named: "youji")
        
        //创建一个tableBarController
        var tabBar = UITabBarController()
        var array = [firstNav,secondNav,third]
        tabBar.viewControllers = array
        
        
        self.window?.rootViewController = tabBar;
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

