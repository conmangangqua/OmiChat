//
//  PhotoViewController.swift
//  OmiChat
//
//  Created by MAC OSX on 2/22/19.
//  Copyright © 2019 Ominext. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    lazy var zoomImageView: ZoomImageView = {
        let view = ZoomImageView(frame: self.view.bounds)
        view.delegate = self
        return view
    }()
    var image: UIImage?
    
     //MARK: Methods
    fileprivate func initImageView() {
        self.zoomImageView.frame = self.view.bounds
        self.zoomImageView.image = image
        
        self.view.insertSubview(zoomImageView, belowSubview: self.topView)
        
        if image == nil {
            self.activityIndicator.startAnimating()
        }
    }
    
    fileprivate func initComponents() {
        // double tap gesture
        let doubleTapGesture = UITapGestureRecognizer()
        doubleTapGesture.addTarget(self, action: #selector(PhotoViewController.didDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTapGesture)
        self.view.tintColor = UIColor.white
        self.view.backgroundColor = UIColor.black
        
        self.modalPresentationStyle = .custom
        self.modalPresentationCapturesStatusBarAppearance = true
        
        self.activityIndicator.isHidden = true
    }
    
    @objc fileprivate func  didDoubleTap(_ sender: UITapGestureRecognizer) {
        let scrollViewSize = self.zoomImageView.bounds.size
        var pointInView = sender.location(in: self.zoomImageView.imageView)
        var newZoomScale = min(zoomImageView.maximumZoomScale, self.zoomImageView.minimumZoomScale * 2)
        
        if let imageSize = zoomImageView.imageView.image?.size, (imageSize.height / imageSize.width) > (scrollViewSize.height / scrollViewSize.width) {
            pointInView.x = zoomImageView.imageView.bounds.width / 2
            let widthScale = scrollViewSize.width / imageSize.width
            newZoomScale = widthScale
        }
        
        let isZoomIn = (zoomImageView.zoomScale >= newZoomScale) || (abs(zoomImageView.zoomScale - newZoomScale) <= 0.01)
        
        if isZoomIn {
            newZoomScale = zoomImageView.minimumZoomScale
        }
        
        zoomImageView.isDirectionalLockEnabled = !isZoomIn
        
        let width = scrollViewSize.width / newZoomScale
        let height = scrollViewSize.height / newZoomScale
        let originX = pointInView.x - (width / 2)
        let originY = pointInView.y - (height / 2)
        
        let rectToZoomTo = CGRect(x: originX, y: originY, width: width, height: height)
        self.zoomImageView.zoom(to: rectToZoomTo, animated: true)
    }
    
    // MARK: Actions
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initImageView()
        self.initComponents()
    }
    
}

extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.zoomImageView.imageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.panGestureRecognizer.isEnabled = true
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            scrollView.panGestureRecognizer.isEnabled = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
}
