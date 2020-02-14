//
//  ArticleDetailViewController.swift
//  NYTTopStories
//
//  Created by Alex Paul on 2/7/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import DataPersistence

class ArticleDetailViewController: UIViewController {
  
  // properties
  private let detailView = ArticleDetailView()

  private var article: Article
  
  private var dataPersistence: DataPersistence<Article>
  
  private lazy var tapGesture: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(self, action: #selector(didTap(_:)))
    return gesture
  }()
  
  private var bookmarkBarButton: UIBarButtonItem!
  
  // initializers
  init(_ dataPersistence: DataPersistence<Article>, article: Article) {
    self.dataPersistence = dataPersistence
    self.article = article
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = detailView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    // adding a UIBarButtonItem to the right side to the navigation bar's title
    bookmarkBarButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(saveArticleButtonPressed(_:)))
    navigationItem.rightBarButtonItem = bookmarkBarButton
    
    updateUI()
    
    // setup tap gesture
    detailView.newsImageView.isUserInteractionEnabled = true
    detailView.newsImageView.addGestureRecognizer(tapGesture)
  }
  
  @objc private func didTap(_ gesture: UITapGestureRecognizer) {
    let image = detailView.newsImageView.image ?? UIImage()
    // we need to get an instance of the ZoomImageViewController from storyboard
    let zoomImageStoryboard = UIStoryboard(name: "ZoomImage", bundle: nil)
    let zoomImageVC = zoomImageStoryboard.instantiateViewController(identifier: "ZoomImageViewController") { coder in
      return ZoomImageViewController(coder: coder, image: image)
    }
    present(zoomImageVC, animated: true)
  }
  
  private func updateUI() {
    updateBookmarkState(article)
    navigationItem.title = article.title
    detailView.abstractHeadline.text = article.abstract
    detailView.newsImageView.getImage(with: article.getArticleImageURL(for: .superJumbo)) { [weak self] (result) in
      switch result {
      case .failure:
        DispatchQueue.main.async {
          self?.detailView.newsImageView.image = UIImage(systemName: "exclamationmark-octogon")
        }
      case .success(let image):
        DispatchQueue.main.async {
          self?.detailView.newsImageView.image = image
        }
      }
    }
  }
  
  @objc func saveArticleButtonPressed(_ sender: UIBarButtonItem) {
    if dataPersistence.hasItemBeenSaved(article) {
      if let index = try? dataPersistence.loadItems().firstIndex(of: article) {
        do {
          try dataPersistence.deleteItem(at: index)
        } catch {
          print("error deleting article: \(error)")
        }
      }
    } else {
      do {
        // save to documents directory
        try dataPersistence.createItem(article)
      } catch {
        print("error saving article: \(error)")
      }
    }
    
    // ADDITION:
    // update bookmark state
    updateBookmarkState(article)
  }
  
  // ADDITION
  private func updateBookmarkState(_ article: Article) {
    if dataPersistence.hasItemBeenSaved(article) {
      bookmarkBarButton.image = UIImage(systemName: "bookmark.fill")
    } else {
      bookmarkBarButton.image = UIImage(systemName: "bookmark")
    }
  }
}
