//
//  LoginViewController.swift
//  OmiChat
//
//  Created by MAC OSX on 2/12/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class LoginViewController: BaseLoginViewController {

    //MARK: Properties
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var rememberSwitch: UISwitch!
    
    //MARK: Methods
    func initView(){
        customTextField()
        customButton()
    }
    
    func customTextField(){
        usernameTxt.customBorder(radius: 20)
        passwordTxt.customBorder(radius: 20)
    }
    
    func customButton(){
        loginBtn.makeRoundedBorder(radius: 20)
    }

    func fillInfo(){
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation"){
            usernameTxt.text = userInformation["email"] as? String
            passwordTxt.text = userInformation["password"] as? String
        }
     }
    
    //MARK: Actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        if self.usernameTxt.text == "" || self.passwordTxt.text == "" {
            self.showAlertWith(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("DontTypeEmaiName", comment: ""))
        } else {
            User.loginEmail(withEmail: self.usernameTxt.text!, password: self.passwordTxt.text! ) { (status) in
                DispatchQueue.main.async {
                    if status == true {
                        if !self.rememberSwitch.isOn {
                            UserDefaults.standard.removeObject(forKey: "userInformation")
                        } else {
                            let userInfo = ["email" : self.usernameTxt.text!, "password" : self.passwordTxt.text!]
                            UserDefaults.standard.set(userInfo, forKey: "userInformation")
                        }
                        User.online(for: (Auth.auth().currentUser?.uid)!, status: true){ (success) in
                        }
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbarController")
                        self.present(vc!, animated: true, completion: nil)
                    } else {
                        self.showAlertWith(title: NSLocalizedString("ErrorTitle", comment: ""), message: NSLocalizedString("SignInError", comment: ""))
                    }
                }
            }
        }
    }
    
    @IBAction func googleButtonTapped(_ sender: Any) {
        self.loginWithGoogle()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "signUpVC") as! SignUpViewController
        self.present(resultViewController, animated:true, completion:nil)
    }

    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fillInfo()
    }
    
}
