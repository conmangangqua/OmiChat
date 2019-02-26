//
//  StickerView.swift
//  OmiChat
//
//  Created by MAC OSX on 2/22/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit

//MARK: Delegates
protocol StickerViewDelegate {
    func selectSticker(name: String)
}

class StickerView: UIView {
    
    //MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate : StickerViewDelegate?
    var stickers = [String]()
    let fileManager = FileManager.default
    
    //MARK: Methods
    override func awakeFromNib() {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.fetchSticker()
    }
    
    func fetchSticker() {
        let docsPath = Bundle.main.resourcePath!.appending("")
        let items = try! fileManager.contentsOfDirectory(atPath: docsPath)
        
        for item in items {
            if item.hasPrefix("194312636"){
                stickers.append(item)
            }
        }
    }
    
}

extension StickerView: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.stickers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerCell", for: indexPath) as! StickerCollectionViewCell
        cell.stickerPic.image = UIImage(named: stickers[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageSize = CGSize(width: self.frame.width / 4, height: self.frame.width / 4)
        return imageSize;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectSticker(name: stickers[indexPath.row])
    }
}
