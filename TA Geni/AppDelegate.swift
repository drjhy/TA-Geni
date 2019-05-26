//
//  AppDelegate.swift
//  TA Geni
//
//  Created by John Young on 2/15/19.
//  Copyright © 2019 John Young. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        print(Realm.Configuration.defaultConfiguration.fileURL as Any)

        let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in

            if (oldSchemaVersion < 1) {
            }
        })
        Realm.Configuration.defaultConfiguration = config

        _ = try! Realm()

        return true
    }
}


