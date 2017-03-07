
//
//  ImageViewController.swift
//  Cassini
//
//  Created by 买明 on 07/03/2017.
//  Copyright © 2017 买明. All rights reserved.
//

import UIKit

// 利用扩展代理 UIScrollViewDelegate
extension ImageViewController: UIScrollViewDelegate {
    // 缩放
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

class ImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            // 设置代理
            scrollView.delegate = self
            
            // 缩放控制
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
            
            // UIScrollView 内容大小
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    var imgURL: URL? {
        didSet {
            image = nil
            
            if view.window != nil {
                fetchImage()
            }
        }
    }
    fileprivate var imageView = UIImageView()
    private var image: UIImage? {
        get {
            return imageView.image
        }
        
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            
            scrollView.contentSize = imageView.frame.size
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgURL = DemoURL.stanford
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 视图将要显示时获取图片（耗时）
        if image == nil {
            fetchImage()
        }
    }
    
    private func fetchImage() {
        if let url = imgURL {
            // 捕获错误，返回可选
            let urlContents = try? Data(contentsOf: url)
            if let imageData = urlContents {
                image = UIImage(data: imageData)
            }
        }
    }
    
}
