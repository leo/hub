//
//  AppDelegate.swift
//  GitHub
//
//  Created by Leonard Lamprecht on 14/05/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var loginView: UIViewController?
    var welcomeView: UIViewController?

    var token: String? {
        get {
            guard let token = defaults.stringForKey("api_token") else {
                return nil
            }

            return token
        }
        set {
            defaults.setValue(newValue, forKey: "api_token")
            defaults.synchronize()
        }
    }

    var loggedIn: Bool {
        get {
            if token != nil {
                return true
            }

            return false
        }
    }

    var segue: UIStoryboardSegue?

    let connector: Connector = Connector()
    let mainView: UIViewController = MainViewController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let initialView = loggedIn ? "Main" : "Welcome"

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewControllerWithIdentifier(initialView) as UIViewController

        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let urlComponents = NSURLComponents(string: url.absoluteString)
        
        guard let queryItems = urlComponents?.queryItems else {
            fatalError()
        }
        
        do {
            try connector.requestAccessToken((queryItems[0].value)!, state: (queryItems[1].value)!, completion: {
                self.loginView?.performSegueWithIdentifier("showMain", sender: nil)
            })
        } catch {
            fatalError(String(error))
        }
        
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

