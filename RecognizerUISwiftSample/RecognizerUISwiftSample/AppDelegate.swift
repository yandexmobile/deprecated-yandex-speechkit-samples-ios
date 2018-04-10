//
//  AppDelegate.swift
//
//  This file is a part of the samples for Yandex SpeechKit Mobile SDK.
//  Version for iOS © 2018 Yandex LLC.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Configure SpeechKit lib, this method should be called _before_ any SpeechKit functions.
        // Generate your own app key for this purpose.
        YSKSpeechKit.sharedInstance().apiKey = "developer_app_key"

        // [OPTIONAL] Set SpeechKit log level, for more options see YSKLogLevel enum.
        YSKSpeechKit.sharedInstance().logLevel = .error

        // Required for online requests
        YSKSpeechKit.sharedInstance().uuid = "application_uuid";

        window = UIWindow(frame: UIScreen.main.bounds);

        let navigationController = UINavigationController(rootViewController: YSKRecognizerViewController());
        navigationController.navigationBar.isTranslucent = false
        window?.rootViewController = navigationController

        window?.makeKeyAndVisible();
        
        return true
    }
}

