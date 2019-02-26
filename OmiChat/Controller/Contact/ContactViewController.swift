//
//  ContactViewController.swift
//  OmiChat
//
//  Created by MAC OSX on 2/18/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit
import Firebase

class ContactViewController: UIViewController {

    //MARK: Actions
    @IBOutlet weak var collectionView: UICollectionView!
    let currentUser = Auth.auth().currentUser
    var items = [User]()
    var filteredItems = [User]()
    var selectedUser: User?
    
    //MARK: Methods
    func fetchUsers()  {
        if let id = currentUser?.uid {
            self.items.removeAll()
            User.downloadAllUsers(exceptID: id, completion: {(user) in
                DispatchQueue.main.async {
                    self.items.append(user)
                    self.items.sort{ $0.name < $1.name }
                    self.filteredItems = self.items
                    self.collectionView.reloadData()
                }
            })
        }
    }
    
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchUsers()
    }
    
}

extension ContactViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.filteredItems.count == 0 {
            return 1
        } else {
            return self.filteredItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.filteredItems.count == 0 {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UserCollectionViewCell
            cell.profilePic.image = self.filteredItems[indexPath.row].profilePic
            cell.nameLabel.text = self.filteredItems[indexPath.row].name
            if self.filteredItems[indexPath.row].isOnline == true {
                cell.onlineImage.backgroundColor = GlobalVariables.green
            } else {
                cell.onlineImage.backgroundColor = UIColor.red
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.filteredItems.count > 0 {
            self.selectedUser = self.filteredItems[indexPath.row]
            if let currentUserID = currentUser?.uid {
                Conversation.createConversations(forUserID: currentUserID, userEmail: (currentUser?.email)!, withUser: selectedUser!) {(success) in
                }
            }
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let resultViewController = storyBoard.instantiateViewController(withIdentifier: "chatVC") as! ChatViewController
            resultViewController.currentUser = self.selectedUser
            
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = CATransitionType.fade
            transition.subtype = CATransitionSubtype.fromBottom
            view.window!.layer.add(transition, forKey: kCATransition)
            
            self.present(resultViewController, animated: false, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.filteredItems.count == 0 {
            return self.collectionView.bounds.size
        } else {
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                let width = (0.3 * UIScreen.main.bounds.height)
                let height = width + 30
                return CGSize.init(width: width, height: height)
            } else {
                let width = (0.3 * UIScreen.main.bounds.width)
                let height = width + 30
                return CGSize.init(width: width, height: height)
            }
        }
    }
}

extension ContactViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let newItems = items.filter{ ($0.name.uppercased().contains(searchText.uppercased())) }
        self.filteredItems = searchText.isEmpty ? self.items : newItems
        self.collectionView.reloadData()
    }
}
