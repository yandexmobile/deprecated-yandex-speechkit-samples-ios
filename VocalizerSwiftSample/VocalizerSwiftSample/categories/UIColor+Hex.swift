//
//  UIColor+Hex.swift
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

import Foundation

extension UIColor {

    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }

    convenience init(hex: String, alpha: Float) {
        var rgbValue: CUnsignedInt = 0
        let scanner = Scanner(string: hex)
        scanner.scanHexInt32(&rgbValue)
        self.init(red:CGFloat(((rgbValue & 0xFF0000) >> 16))/255.0, green: CGFloat(((rgbValue & 0x00FF00) >> 8))/255.0, blue: CGFloat(((rgbValue & 0x0000FF) >> 0))/255.0, alpha: CGFloat(alpha))
    }
}
