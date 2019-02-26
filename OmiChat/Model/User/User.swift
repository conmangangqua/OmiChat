//
//  User.swift
//  OmiChat
//
//  Created by MAC OSX on 2/13/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class User {

    //MARK: Properties
    let name: String
    let email: String
    let id: String
    let isOnline: Bool
    var profilePic: UIImage
    
    //MARK: Methods
    class func registerUser(withName: String, email: String, password: String, profilePic: UIImage, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                let storageRef = Storage.storage().reference().child("usersProfilePics").child((user?.user.uid)!)
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                storageRef.putData((profilePic.jpegData(compressionQuality: 0.1))!, metadata: metadata, completion: { (metadata, err) in
                    if err == nil {
                        storageRef.downloadURL { url, error in
                            let values = ["name": withName, "email": email, "profilePicLink": url!.absoluteString, "isOnline": false] as [String : Any]
                            Database.database().reference().child("users").child((user?.user.uid)!).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
                                if errr == nil {
                                    let userInfo = ["email" : email, "password" : password]
                                    UserDefaults.standard.set(userInfo, forKey: "userInformation")
                                    completion(true)
                                }
                            })
                        }
                    }
                })
            } else {
                completion(false)
            }
        })
    }
    
    class func loginEmail(withEmail: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error == nil {
                let userInfo = ["email": withEmail, "password": password]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    class func loginGoogle(withCredential: AuthCredential, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().signInAndRetrieveData(with: withCredential) { (user, error) in
            if (error) != nil {
                print("Google Authentification Fail")
                completion(false)
            } else {
                print("Google Authentification Success")
                let values = ["name": user?.user.displayName as Any, "email": user?.user.email as Any, "profilePicLink": user?.user.photoURL?.absoluteString as Any, "isOnline": false] as [String : Any]
                Database.database().reference().child("users").child((user?.user.uid)!).child("credentials").updateChildValues(values as [AnyHashable : Any])
                UserDefaults.standard.removeObject(forKey: "userInformation")
                completion(true)
            }
        }
    }
    
    
    class func online(for uid: String, status: Bool, completion: @escaping (Bool) -> Void) {
        let onlinesRef = Database.database().reference().child("users").child(uid).child("credentials").child("isOnline")
        onlinesRef.setValue(status) {(error, _ ) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                completion(false)
            }
            completion(true)
        }
    }
    
    class func info(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").child(forUserID).child("credentials").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                let name = data["name"]! as! String
                let email = data["email"]! as! String
                let link = URL(string: data["profilePicLink"]! as! String)
                let isOnline = data["isOnline"] as! Bool
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage(data: data!)
                        if profilePic == nil {
                            let user = User.init(name: name, email: email, id: forUserID, isOnline: isOnline, profilePic: UIImage(named: "loading.png")!)
                            completion(user)
                        } else {
                            let user = User.init(name: name, email: email, id: forUserID, isOnline: isOnline, profilePic: profilePic!)
                            completion(user)
                        }
                    }
                }).resume()
            }
        })
    }
    
    class func updateProfileInfo(image: UIImage, name: String, completion: @escaping (Bool) -> Swift.Void){
        let filePath = "usersProfilePics/\(String(describing: Auth.auth().currentUser?.uid))"
        let profileImgReference = Storage.storage().reference().child(filePath)
        let data = image.jpegData(compressionQuality: 0.1)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        _ = profileImgReference.putData(data!, metadata: metadata) { (metadata, error) in
            if error != nil {
                completion(false)
            } else {
                profileImgReference.downloadURL(completion: { (url, error) in
                    if let url = url {
                        if let request = Auth.auth().currentUser?.createProfileChangeRequest(){
                            request.displayName = name
                            request.photoURL = url
                            request.commitChanges(completion: { (error) in
                            })
                        }
                        let userRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
                        let value = ["email": Auth.auth().currentUser?.email, "name": name, "profilePicLink": url.absoluteString]
                        userRef.updateChildValues(["credentials": value])
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            }
        }
    }
    
    class func downloadAllUsers(exceptID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            let data = snapshot.value as! [String: Any]
            let credentials = data["credentials"] as! [String: Any]
            if id != exceptID {
                let name = credentials["name"]! as! String
                let email = credentials["email"]! as! String
                let link = URL.init(string: credentials["profilePicLink"]! as! String)
                let isOnline = credentials["isOnline"] as! Bool
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        if profilePic == nil {
                            let user = User.init(name: name, email: email, id: id, isOnline: isOnline, profilePic: UIImage(named: "loading.png")!)
                            completion(user)
                        } else {
                            let user = User.init(name: name, email: email, id: id, isOnline: isOnline, profilePic: profilePic!)
                            completion(user)
                        }
                        
                    }
                }).resume()
            }
        })
    }
    
    class func logOutUser(forUserID: String, completion: @escaping (Bool) -> Swift.Void) {
        do {
            try Auth.auth().signOut()
            User.online(for: forUserID, status: false){ (success) in
                print("Offline")
            }
            UserDefaults.standard.removeObject(forKey: "userInformation")
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
    //MARK: Inits
    init(name: String, email: String, id: String, isOnline: Bool, profilePic: UIImage) {
        self.name = name
        self.email = email
        self.id = id
        self.isOnline = isOnline
        self.profilePic = profilePic
    }
    
}
