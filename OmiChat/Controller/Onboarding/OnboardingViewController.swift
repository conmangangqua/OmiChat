//
//  OnboardingViewController.swift
//  OmiChat
//
//  Created by MAC OSX on 2/12/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //MARK: Methods
    func initView(){
        customButton()
    }
    
    func customButton(){
        signUpBtn.makeRoundedBorder(radius: 10)
        loginBtn.makeRoundedBorder(radius: 10)
    }

    //MARK: Actions
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "signUpVC") as! SignUpViewController
        self.present(resultViewController, animated:true, completion:nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        self.present(resultViewController, animated:true, completion:nil)
    }
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
}
