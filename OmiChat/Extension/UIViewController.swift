//
//  UIViewController.swift
//  OmiChat
//
//  Created by MAC OSX on 2/19/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    @objc func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
