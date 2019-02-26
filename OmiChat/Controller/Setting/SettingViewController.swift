//
//  SettingViewController.swift
//  OmiChat
//
//  Created by MAC OSX on 2/13/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    //MARK: Methods
    func initView(){
        customTextField()
        customButton()
        fetchUserInfo()
    }
    
    func customTextField(){
        usernameTxt.customBorder(radius: 20)
        emailTxt.customBorder(radius: 20)
    }
    
    func customButton(){
        saveBtn.makeRoundedBorder(radius: 20)
    }
    
    func fetchUserInfo() {
        if let id = Auth.auth().currentUser?.uid {
            User.info(forUserID: id, completion: {(user) in
                DispatchQueue.main.async {
                    self.usernameTxt.text = user.name
                    self.emailTxt.text = user.email
                    self.profileImageView.image = user.profilePic
                }
            })
        }
    }
    
    //MARK: Actions
    @IBAction func profileImageTapped(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        User.updateProfileInfo(image: profileImageView.image!, name: usernameTxt.text!) {(success) in
            if success == true {
                self.showAlertWith(title: "Success", message: "Your information changed.")
            }
        }
        usernameTxt.endEditing(false)
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        User.logOutUser(forUserID: (Auth.auth().currentUser?.uid)!) { (status) in
            if status == true {
                UserDefaults.standard.removeObject(forKey: "userInformation")
                UserDefaults.standard.removeObject(forKey: "googleSignInInfo")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC")
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
}

extension SettingViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        DispatchQueue.main.async {
            self.profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
