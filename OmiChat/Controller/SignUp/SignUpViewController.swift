//
//  SignUpViewController.swift
//  OmiChat
//
//  Created by MAC OSX on 2/12/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import NVActivityIndicatorView

class SignUpViewController: BaseLoginViewController, NVActivityIndicatorViewable {

    //MARK: Properties
    @IBOutlet weak var profilePic: RoundedImageView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    //MARK: Methods
    func initView(){
        customTextField()
        customButton()
    }
    
    func customTextField(){
        emailTxt.customBorder(radius: 20)
        passwordTxt.customBorder(radius: 20)
        usernameTxt.customBorder(radius: 20)
    }
    
    func customButton(){
        signUpBtn.makeRoundedBorder(radius: 20)
    }

    //MARK: Actions
    @IBAction func signUpButtonTapped(_ sender: Any) {
        if emailTxt.text == "" || usernameTxt.text == ""{
            self.showAlertWith(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("DontTypeEmaiName", comment: ""))
        } else {
            let size = CGSize(width: 30, height: 30)
            self.startAnimating(size, message: NSLocalizedString("NVActivityIndicatorViewTitle", comment: ""), type: NVActivityIndicatorType.ballRotateChase, fadeInAnimation: nil)
            let email = emailTxt.text
            let username = usernameTxt.text
            let passWord = passwordTxt.text
            let image = profilePic.image
            User.registerUser(withName: username!, email: email!, password: passWord!, profilePic: image!) { (success) in
                DispatchQueue.main.async {
                    self.stopAnimating(nil)
                    if success == true {
                        let alertController = UIAlertController(title: NSLocalizedString("CongratsContent", comment: ""), message: NSLocalizedString("Congrats", comment: ""), preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default) {
                            UIAlertAction in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
                            self.present(vc!, animated: true, completion: nil)
                        }
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        self.showAlertWith(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("CantRegister", comment: ""))
                    }
                }
            }
        }
    }
    
    @IBAction func profilePicTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func googleButtonTapped(_ sender: Any) {
      self.loginWithGoogle()
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

extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("\(info)")
        }
        
        DispatchQueue.main.async {
            self.profilePic.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

