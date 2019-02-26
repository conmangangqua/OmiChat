//
//  MessageTableViewCell.swift
//  OmiChat
//
//  Created by MAC OSX on 2/18/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messagePic: UIImageView!
    
    //MARK: Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        messageView.layer.cornerRadius = 10
        messageView.clipsToBounds = true
        messagePic.layer.cornerRadius = 15
        messagePic.clipsToBounds = true
    }
    
    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
        self.messagePic.image = nil
        self.messagePic.isHidden = false
        self.messageView.layer.backgroundColor = UIColor.clear.cgColor
    }
    
}

class ReceiverCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messagePic: UIImageView!

    //MARK: Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        messageView.layer.cornerRadius = 10
        messageView.clipsToBounds = true
        messagePic.layer.cornerRadius = 15
        messagePic.clipsToBounds = true
    }
    
    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
        self.messagePic.image = nil
        self.messagePic.isHidden = false
        self.messageView.layer.backgroundColor = UIColor.clear.cgColor
    }
    
}
