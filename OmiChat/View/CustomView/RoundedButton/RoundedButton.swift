//
//  RoundedButton.swift
//  OmiChat
//
//  Created by MAC OSX on 2/22/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
