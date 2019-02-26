//
//  ZoomImageView.swift
//  OmiChat
//
//  Created by MAC OSX on 2/22/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit

class ZoomImageView: UIScrollView {
    
    var image: UIImage? {
        didSet {
            if let image = image {
                self.updateWithImage(image)
            }
        }
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    // Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bouncesZoom = true
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        self.addSubview(imageView)
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not implemented")
    }
    
    // Setup
    
    fileprivate func setupWithImage(_ image: UIImage) {
        self.updateWithImage(image)
    }
    
    fileprivate func updateWithImage(_ image: UIImage) {
        imageView.transform = CGAffineTransform.identity
        imageView.image = image
        imageView.frame = CGRect(origin: CGPoint.zero, size: image.size)
        
        contentSize = image.size
        
        self.updateZoomScaleWithImage(image)
        self.centerContent()
    }
    
    fileprivate func updateZoomScaleWithImage(_ image: UIImage) {
        let scrollViewFrame = bounds
        let imageSize = image.size
        
        let widthScale = scrollViewFrame.width / imageSize.width
        let heightScale = scrollViewFrame.height / imageSize.height
        
        let minScale = min(widthScale, heightScale)
        
        self.minimumZoomScale = minScale
        self.maximumZoomScale = minScale * 4
        
        if (imageSize.height / imageSize.width) > (scrollViewFrame.height / scrollViewFrame.width) {
            self.maximumZoomScale = max(maximumZoomScale, widthScale)
        }
        
        self.zoomScale = minimumZoomScale
        self.panGestureRecognizer.isEnabled = false
    }
    
    fileprivate func centerContent() {
        var horizontalInset: CGFloat = 0.0
        var verticalInset: CGFloat = 0.0
        
        if contentSize.width < bounds.width {
            horizontalInset = (bounds.width - contentSize.width) * 0.5
        }
        
        if contentSize.height < bounds.height {
            verticalInset = (bounds.height - contentSize.height) * 0.5
        }
        
        if let scale = window?.screen.scale, scale < 2 {
            horizontalInset = floor(horizontalInset)
            verticalInset = floor(verticalInset)
        }
        
        self.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
    
    
}

