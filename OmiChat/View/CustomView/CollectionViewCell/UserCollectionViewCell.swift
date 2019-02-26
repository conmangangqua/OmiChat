//
//  UserCollectionViewCell.swift
//  OmiChat
//
//  Created by MAC OSX on 2/18/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var onlineImage: RoundedImageView!
    
    //MARK: Methods
    override func awakeFromNib() {
    }
    
}
