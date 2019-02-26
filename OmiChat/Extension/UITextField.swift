//
//  UITextField.swift
//  OmiChat
//
//  Created by MAC OSX on 2/12/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit

extension UITextField {
    func customBorder(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red:0.66, green:0.89, blue:0.56, alpha:1.0).cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
    }
}
