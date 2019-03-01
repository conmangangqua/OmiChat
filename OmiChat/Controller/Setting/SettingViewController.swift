//
//  SettingViewController.swift
//  OmiChat
//
//  Created by MAC OSX on 2/13/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class SettingViewController: UIViewController, NVActivityIndicatorViewable {

    //MARK: Properties
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var languageBtn: RoundedButton!
    @IBOutlet weak var titleLbl: UILabel!
    
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
    
    func getLanguage(){
        let language = LocalizationSystem.sharedInstance.getLanguage()
        if language == "vi" {
            languageBtn.setImage(UIImage(named: "vietnam"), for: .normal)
        } else {
            languageBtn.setImage(UIImage(named: "united-states"), for: .normal)
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
        let size = CGSize(width: 30, height: 30)
        self.startAnimating(size, message: NSLocalizedString("NVActivityIndicatorViewTitle", comment: ""), type: NVActivityIndicatorType.ballRotateChase, fadeInAnimation: nil)
        User.updateProfileInfo(image: profileImageView.image!, name: usernameTxt.text!) {(success) in
            self.stopAnimating(nil)
            if success == true {
                self.showAlertWith(title: NSLocalizedString("SaveInfoTitle", comment: ""), message: NSLocalizedString("SaveInfoContent", comment: ""))
            }
        }
        usernameTxt.endEditing(false)
    }
    @IBAction func languageButtonTapped(_ sender: UIButton) {
        if LocalizationSystem.sharedInstance.getLanguage() == "vi" {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            languageBtn.setImage(UIImage(named: "united-states"), for: .normal)
        } else {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "vi")
            languageBtn.setImage(UIImage(named: "vietnam"), for: .normal)
        }
        self.showAlertWith(title: NSLocalizedString("ChangeLanguageTitle", comment: ""), message: NSLocalizedString("ChangeLanguageContent", comment: ""))
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        User.logOutUser(forUserID: (Auth.auth().currentUser?.uid)!) { (status) in
            if status == true {
                UserDefaults.standard.removeObject(forKey: "userInformation")
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.getLanguage()
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
