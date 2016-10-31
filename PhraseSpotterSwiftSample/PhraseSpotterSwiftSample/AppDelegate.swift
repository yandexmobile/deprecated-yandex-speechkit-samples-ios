//
//  AppDelegate.swift
//
//  This file is a part of the samples for Yandex SpeechKit Mobile SDK.
//  Version for iOS © 2016 Yandex LLC.
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
        YSKSpeechKit.sharedInstance().configure(withAPIKey: "f4fdf7ae-1b29-4af3-8fc8-04dc57bffc1a");

        // [OPTIONAL] Set SpeechKit log level, for more options see YSKLogLevel enum.
        YSKSpeechKit.sharedInstance().setLogLevel(YSKLogLevel(YSKLogLevelWarn));

        // [OPTIONAL] Set YSKSpeechKit parameters, for all parameters and possible values see documentation.
        YSKSpeechKit.sharedInstance().setParameter(YSKDisableAntimat, withValue: "false");

        window = UIWindow(frame: UIScreen.main.bounds);

        let phraseSpotterModelConfigDir = Bundle.main.resourcePath?.appending("/phrase_spotter_model")
        let recognizerController = YSKPhraseSpotterViewController(modelDirectory: phraseSpotterModelConfigDir!)
        let navigationController = UINavigationController(rootViewController: recognizerController);
        navigationController.navigationBar.isTranslucent = false
        window?.rootViewController = navigationController

        window?.makeKeyAndVisible();

        return true
    }
}

