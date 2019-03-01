//
//  ConversationViewController.swift
//  OmiChat
//
//  Created by MAC OSX on 2/13/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit
import Firebase

class ConversationViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var warningBtn: RoundedButton!
    var items = [Conversation]()
    var selectedUser: User?
    
    //MARK: Methods
    func fetchData() {
        self.items.removeAll()
        Conversation.showConversations { (conversations) in
            self.items = conversations
            self.items.sort{ $0.lastMessage.timestamp > $1.lastMessage.timestamp }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                for conversation in self.items {
                    if conversation.lastMessage.isRead == false {
                        break
                    }
                }
            }
        }
    }
    
    func checkUserVerification(){
        User.checkUserVerification {(status) in
            self.warningBtn.isHidden = status
        }
    }
    
    //MARK: Action
    @IBAction func warningButtonTapped(_ sender: Any) {
        self.showAlertWith(title: NSLocalizedString("VerifiedEmailTitle", comment: ""), message: NSLocalizedString("VerifiedEmailContent", comment: ""))
    }
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
        self.checkUserVerification()    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
}

extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items.count == 0 {
            return 1
        } else {
            return self.items.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items.count {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell")!
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationsTableCell
            cell.clearCellData()
            cell.profilePic.image = self.items[indexPath.row].user.profilePic
            let username = self.items[indexPath.row].user.name
            cell.nameLabel.text = username
            switch self.items[indexPath.row].lastMessage.type {
            case .text:
                let message = self.items[indexPath.row].lastMessage.content as! String
                if self.items[indexPath.row].lastMessage.owner == .sender {
                    cell.messageLabel.text = message
                } else {
                    cell.messageLabel.text = NSLocalizedString("You : ", comment: "") + message
                }
            case .photo:
                if self.items[indexPath.row].lastMessage.owner == .sender {
                    cell.messageLabel.text = username + NSLocalizedString(" send a photo.", comment: "")
                } else {
                    cell.messageLabel.text = NSLocalizedString("You send a photo.", comment: "")
                }
            case .sticker:
                if self.items[indexPath.row].lastMessage.owner == .sender {
                    cell.messageLabel.text = username + NSLocalizedString(" send a sticker.", comment: "")
                } else {
                    cell.messageLabel.text = NSLocalizedString("You send a sticker.", comment: "")
                }
            case .location:
                if self.items[indexPath.row].lastMessage.owner == .sender {
                    cell.messageLabel.text = username + NSLocalizedString(" send a location.", comment: "")
                } else {
                    cell.messageLabel.text = NSLocalizedString("You send a location.", comment: "")
                }
            }
            let messageDate = Date(timeIntervalSince1970: TimeInterval(self.items[indexPath.row].lastMessage.timestamp))
            let dataformatter = DateFormatter()
            dataformatter.timeStyle = .short
            let date = dataformatter.string(from: messageDate)
            cell.timeLabel.text = date
            if self.items[indexPath.row].lastMessage.owner == .sender && self.items[indexPath.row].lastMessage.isRead == false {
                cell.nameLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 17.0)
                cell.messageLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 14.0)
                cell.timeLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 13.0)
                cell.messageLabel.textColor = GlobalVariables.purple
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.items.count > 0 {
            self.selectedUser = self.items[indexPath.row].user
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "chatVC") as! ChatViewController
            resultViewController.currentUser = self.selectedUser
            
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = CATransitionType.fade
            transition.subtype = CATransitionSubtype.fromBottom
            view.window!.layer.add(transition, forKey: kCATransition)

            self.present(resultViewController, animated: false, completion: nil)
        }
    }

}




