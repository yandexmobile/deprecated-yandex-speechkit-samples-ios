//
//  YSKAppearanceSettings.swift
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

class YSKAppearanceSettings {

    class func apply() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: YSKAppearanceSettings.font()]
        UINavigationBar.appearance().tintColor = YSKAppearanceSettings.tintColor()
        UITableView.appearance().tintColor = YSKAppearanceSettings.tintColor()
        UIProgressView.appearance().progressTintColor = YSKAppearanceSettings.backgroundColor(0.8)
        UIProgressView.appearance().trackTintColor = YSKAppearanceSettings.tintColor(0.8)
    }

    class func tintColor() -> UIColor {
        return tintColor(1.0)
    }

    class func tintColor(_ alpha: Float) -> UIColor {
        return UIColor(hex: "0x4065A0", alpha: alpha)
    }

    class func backgroundColor() -> UIColor {
        return backgroundColor(0.5)
    }

    class func backgroundColor(_ alpha: Float) -> UIColor {
        return UIColor(hex: "0xFFFFFF", alpha: alpha)
    }

    class func font() -> UIFont {
        return font(17.0)
    }

    class func font(_ size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: size)!
    }
}
