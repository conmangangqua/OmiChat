//
//  UIButton.swift
//  OmiChat
//
//  Created by MAC OSX on 2/12/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func makeRoundedBorder(radius: CGFloat) -> Void {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.white.cgColor
    }
}

