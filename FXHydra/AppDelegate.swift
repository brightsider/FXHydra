//
//  AppDelegate.swift
//  FXHydra
//
//  Created by kioshimafx on 3/12/16.
//  Copyright © 2016 FXSolutions. All rights reserved.
//

import UIKit
import VK_ios_sdk


// ###### XCGLogger #####

let documentsDirectory: NSURL = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.endIndex - 1]
}()

let cacheDirectory: NSURL = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
    return urls[urls.endIndex - 1]
}()

let log: XCGLogger = {
    // Setup XCGLogger
    let log = XCGLogger.defaultInstance()
    log.xcodeColorsEnabled = true // Or set the XcodeColors environment variable in your scheme to YES
    log.xcodeColors = [
        .Verbose: .lightGrey,
        .Debug: .darkGrey,
        .Info: .darkGreen,
        .Warning: .orange,
        .Error: XCGLogger.XcodeColor(fg: UIColor.redColor(), bg: UIColor.whiteColor()), // Optionally use a UIColor
        .Severe: XCGLogger.XcodeColor(fg: (255, 255, 255), bg: (255, 0, 0)) // Optionally use RGB values directly
    ]
    
    let logPath: NSURL = cacheDirectory.URLByAppendingPathComponent("FXHydra_Log.txt")
    log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: logPath)
    
    return log
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.clearColor()
        window.rootViewController = FXInterfaceService.sharedManager().rootNavController
        window.makeKeyAndVisible()
        self.window = window
        
        ///
        
        
        ///
        
        FXDatabaseService.sharedManager()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        FXSignalsService.sharedManager().appChangeStateToBackground.fire(true)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FXSignalsService.sharedManager().appChangeStateToBackground.fire(false)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        VKSdk.processOpenURL(url, fromApplication: sourceApplication)
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if #available(iOS 9.0, *) {
            VKSdk.processOpenURL(url, fromApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String)
        } else {
            // Fallback on earlier versions
        }
        return true
    }


}
