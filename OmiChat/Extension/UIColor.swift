//
//  UIColor.swift
//  OmiChat
//
//  Created by MAC OSX on 2/20/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    class func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }
}
