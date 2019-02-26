//
//  Helper Files.swift
//  OmiChat
//
//  Created by MAC OSX on 2/15/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import Foundation
import UIKit

//GlobalVariables
struct GlobalVariables {
    static let green = UIColor.rbg(r: 168, g: 228, b: 144)
    static let blue = UIColor.rbg(r: 129, g: 144, b: 255)
    static let purple = UIColor.rbg(r: 161, g: 114, b: 255)
}

//Enums
enum ViewControllerType {
    case onboarding
    case home
}

enum ImageSource {
    case photoLibrary
    case camera
}

enum MessageType {
    case photo
    case text
    case sticker
}

enum MessageOwner {
    case sender
    case receiver
}

