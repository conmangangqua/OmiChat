//
//  RoundedImageView.swift
//  OmiChat
//
//  Created by MAC OSX on 2/22/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import Foundation
import UIKit

class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
