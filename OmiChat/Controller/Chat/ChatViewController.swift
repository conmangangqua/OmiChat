//
//  ChatViewController.swift
//  OmiChat
//
//  Created by MAC OSX on 2/13/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit
import Photos

class ChatViewController: UIViewController, StickerViewDelegate {
   
     //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var onlineLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var stickerView: StickerView!
    @IBOutlet weak var keyboardBtn: UIButton!
    var imagePicker: UIImagePickerController!
    var items = [Message]()
    var currentUser: User?
    
   //MARK: Methods
    func configTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    func configStickerView(){
        self.view.addSubview(stickerView)
        stickerView.delegate = self
        self.stickerView.translatesAutoresizingMaskIntoConstraints = false
        self.stickerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.stickerView.topAnchor.constraint(equalTo: self.stackView.bottomAnchor).isActive = true
        self.stickerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.stickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func fetchData() {
        Message.downloadAllMessages(forUserID: self.currentUser!.id, completion: {[weak weakSelf = self] (message) in
            weakSelf?.items.append(message)
            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
            DispatchQueue.main.async {
                if let state = weakSelf?.items.isEmpty, state == false {
                    weakSelf?.tableView.reloadData()
                    weakSelf?.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                }
            }
        })
        Message.markMessagesRead(forUserID: self.currentUser!.id)
    }
    
    func composeMessage(type: MessageType, width : Int, height: Int, content: Any)  {
        let message = Message.init(type: type, content: content, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), width: width, height: height, isRead: false)
        Message.send(message: message, toID: self.currentUser!.id, completion: {(_) in
        })
    }
    
    func clearBackgroundButton(){
        for view in stackView.subviews{
            let button = view as! UIButton
            button.backgroundColor = UIColor.white
        }
        inputTextField.resignFirstResponder()
        bottomConstraint.constant = 0
    }
    
    func selectSticker(name: String) {
        self.composeMessage(type: .sticker, width: 80, height: 80, content: name)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    //MARK: Actions
    @IBAction func backButtonTapped(_ sender: Any) {
        Message.markMessagesRead(forUserID: self.currentUser!.id)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "tabbarController") as! UITabBarController
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(resultViewController, animated: false, completion: nil)
    }
    
    @IBAction func keyboardButtonTapped(_ sender: UIButton) {
        clearBackgroundButton()
        sender.backgroundColor = GlobalVariables.green
        inputTextField.becomeFirstResponder()
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        clearBackgroundButton()
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            self.showAlertWith(title: "Warning", message: "You don't have camera")
            return
        }
        self.selectImageFrom(.camera)
    }
    
    @IBAction func photoButtonTapped(_ sender: Any) {
        clearBackgroundButton()
        self.selectImageFrom(.photoLibrary)
    }
    
    @IBAction func stickerButtonTapped(_ sender: UIButton) {
        clearBackgroundButton()
        sender.backgroundColor = GlobalVariables.green
        bottomConstraint.constant = 250
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        clearBackgroundButton()
        if let text = self.inputTextField.text {
            if text.count > 0 {
                self.composeMessage(type: .text, width: 0, height: 0, content: self.inputTextField.text!)
                self.inputTextField.text = ""
            }
        }
    }
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configStickerView()
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        User.info(forUserID: (currentUser?.id)!, completion: {(user) in
            DispatchQueue.main.async {
                self.titleLabel.text = self.currentUser?.name
                if user.isOnline == true {
                    self.onlineLbl.text = "Online"
                } else {
                    self.onlineLbl.text = "Offline"
                }
            }
        })
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items[indexPath.row].owner {
        case .receiver:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
            cell.clearCellData()
            switch self.items[indexPath.row].type {
            case .text:
                cell.messageView.backgroundColor = GlobalVariables.green
                cell.messagePic.isHidden = true
                cell.message.text = (self.items[indexPath.row].content as! String)
            case .sticker:
                cell.message.isHidden = true
                let newImage = self.resizeImage(image: UIImage(named: self.items[indexPath.row].content as!String)!, targetSize: CGSize(width: 80, height: 80))
                cell.messagePic.image = newImage
            case .photo:
                cell.message.isHidden = true
                var widthImage = self.items[indexPath.row].width
                var heightImage = self.items[indexPath.row].height
                if widthImage > 250 {
                    heightImage = 250 * heightImage / widthImage
                    widthImage = 250
                }
                if heightImage > 250 {
                    widthImage = 250 * widthImage / heightImage
                    heightImage = 250
                }
                cell.messagePic.image = self.resizeImage(image: UIImage(named: "white")!, targetSize: CGSize(width: CGFloat(widthImage), height: CGFloat(heightImage)))
                if let image = self.items[indexPath.row].image {
                    let newImage = self.resizeImage(image: image, targetSize: CGSize(width: CGFloat(widthImage), height: CGFloat(heightImage)))
                    cell.messagePic.image = newImage
                } else {
                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                            }
                        }
                    })
                }
            }
            return cell
        case .sender:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
            cell.clearCellData()
            cell.profilePic.image = self.currentUser?.profilePic
            switch self.items[indexPath.row].type {
            case .text:
                cell.messageView.backgroundColor = UIColor.red
                cell.messagePic.isHidden = true
                cell.message.text = (self.items[indexPath.row].content as! String)
            case .sticker:
                cell.message.isHidden = true
                let newImage = self.resizeImage(image: UIImage(named: self.items[indexPath.row].content as!String)!, targetSize: CGSize(width: 80, height: 80))
                cell.messagePic.image = newImage
            case .photo:
                cell.message.isHidden = true
                var widthImage = self.items[indexPath.row].width
                var heightImage = self.items[indexPath.row].height
                if widthImage > 250 {
                    heightImage = 250 * heightImage / widthImage
                    widthImage = 250
                }
                if heightImage > 250 {
                    widthImage = 250 * widthImage / heightImage
                    heightImage = 250
                }
                cell.messagePic.image = self.resizeImage(image: UIImage(named: "white")!, targetSize: CGSize(width: CGFloat(widthImage), height: CGFloat(heightImage)))
                if let image = self.items[indexPath.row].image {
                    let newImage = self.resizeImage(image: image, targetSize: CGSize(width: CGFloat(widthImage), height: CGFloat(heightImage)))
                    cell.messagePic.image = newImage
                } else {
                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                            }
                        }
                    })
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.items[indexPath.row].type {
        case .photo:
            if let photo = self.items[indexPath.row].image {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "photoVC") as! PhotoViewController
                resultViewController.image = photo
                self.present(resultViewController, animated: true, completion: nil)
            }
        default:
            break
        }
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.composeMessage(type: .photo, width: Int(selectedImage.size.width), height: Int(selectedImage.size.height), content: selectedImage)
        
        dismiss(animated: true, completion: nil)
    }
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
}
