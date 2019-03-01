//
//  SplashViewController.swift
//  OmiChat
//
//  Created by MAC OSX on 2/12/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SplashViewController: BaseLoginViewController {
    
    //MARK: Methods
    func checkLogin(){
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let email = userInformation["email"] as! String
            let password = userInformation["password"] as! String
            User.loginEmail(withEmail: email, password: password, completion: { (success) in
                DispatchQueue.main.async {
                    if success == true {
                        User.online(for: (Auth.auth().currentUser?.uid)!, status: true){ (success) in
                        }
                        self.pushTo(viewController: .home)
                    }
                }
            })
        } else if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            self.loginWithGoogle()
            self.pushTo(viewController: .home)
        } else {
            self.pushTo(viewController: .onboarding)
        }
    }
    
    func pushTo(viewController: ViewControllerType)  {
        switch viewController {
        case .onboarding:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "onboardingVC") as! OnboardingViewController
            self.present(vc, animated: true, completion: nil)
        case .home:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbarController") as! UITabBarController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func splashTimeOut(sender : Timer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "onboardingVC") as! OnboardingViewController
        self.present(resultViewController, animated:true, completion:nil)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.splashTimeOut(sender:)), userInfo: nil, repeats: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkLogin()
        super.viewDidAppear(animated)
        
    }
}
