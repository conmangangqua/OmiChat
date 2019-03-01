//
//  Conversation.swift
//  OmiChat
//
//  Created by MAC OSX on 2/18/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import Foundation
import Firebase

class Conversation {
    //MARK: Properties
    let user: User
    var lastMessage: Message
    
    //MARK: Methods
    class func createConversations(forUserID: String, userEmail: String, withUser: User, completion: @escaping(Bool) -> Swift.Void) {
        Database.database().reference().child("users").child(forUserID).child("conversations").observe(.value, with: { snapshot in
            if snapshot.exists() {
                let data = snapshot.value as! [String: String]
                if data[withUser.id] == nil {
                    let ref = Database.database().reference().child("conversations").childByAutoId()
                    ref.updateChildValues(["people": [forUserID: userEmail, withUser.id: withUser.email]])
                    Database.database().reference().child("users").child(forUserID).child("conversations").updateChildValues([withUser.id:ref.key!])
                    Database.database().reference().child("users").child(withUser.id).child("conversations").updateChildValues([forUserID:ref.key!])
                    completion(true)
                }
            } else {
                let ref = Database.database().reference().child("conversations").childByAutoId()
                ref.updateChildValues(["people": [forUserID: userEmail, withUser.id: withUser.email]])
                Database.database().reference().child("users").child(forUserID).child("conversations").updateChildValues([withUser.id:ref.key!])
                Database.database().reference().child("users").child(withUser.id).child("conversations").updateChildValues([forUserID:ref.key!])
                completion(true)
            }
        })
    }
    
    class func showConversations(completion: @escaping ([Conversation]) -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            var conversations = [Conversation]()
            Database.database().reference().child("users").child(currentUserID).child("conversations").observe(.childAdded, with: { (snapshot) in
                if snapshot.exists() {
                    let fromID = snapshot.key
                    let id = snapshot.value as! String
                    User.info(forUserID: fromID, completion: { (user) in
                        let emptyMessage = Message.init(type: .text, content: "", owner: .sender, timestamp: 0, width: 0, height: 0, isRead: true)
                        let conversation = Conversation.init(user: user, lastMessage: emptyMessage)
                        conversation.lastMessage.downloadLastMessage(forID: id, completion: {
                            conversations.append(conversation)
                            completion(conversations)
                        })
                    })
                }
            })
        }
    }
    
    //MARK: Inits
    init(user: User, lastMessage: Message) {
        self.user = user
        self.lastMessage = lastMessage
    }
}
