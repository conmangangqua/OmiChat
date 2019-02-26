//
//  BaseLoginViewController.swift
//  OmiChat
//
//  Created by MAC OSX on 2/22/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class BaseLoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    //MARK: Methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if (error) != nil {
            print("An error occured during Google Authentication")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        User.loginGoogle(withCredential: credential) {(status) in
            if status == true {
                User.online(for: (Auth.auth().currentUser?.uid)!, status: true){ (success) in
                    print("Online")
                }
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "tabbarController")
                self.present(resultViewController, animated:true, completion:nil)
            } else {
                self.showAlertWith(title: "Error", message: "Error")
            }
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
