//
//  AppDelegate.swift
//  Job Applicator
//
//  Created by Terence Baker on 2019-02-27.
//  Copyright © 2019 Bulb Studios Ltd. All rights reserved.
//

import UIKit
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    #if DEBUG
    private let logLevel = DDLogLevel.all
    #else
    private let logLevel = DDLogLevel.error
    #endif

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        DDLog.add(DDOSLogger.sharedInstance, with: logLevel)
        return true
    }
}
