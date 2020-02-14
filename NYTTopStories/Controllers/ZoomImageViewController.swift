//
//  ZoomImageViewController.swift
//  NYTTopStories
//
//  Created by Alex Paul on 2/14/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class ZoomImageViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var imageView: UIImageView!
  
  private var image: UIImage
  
  init?(coder: NSCoder, image: UIImage) {
    self.image = image
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.image = image
    scrollView.delegate = self
    scrollView.maximumZoomScale = 5.0
  }
}

extension ZoomImageViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
