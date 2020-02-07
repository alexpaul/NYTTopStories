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
  
  public var article: Article?
  
  public var dataPersistence: DataPersistence<Article>!
  
  private let detailView = ArticleDetailView()
    
  override func loadView() {
    view = detailView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    updateUI()
    
    // adding a UIBarButtonItem to the right side to the navigation bar's title
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(saveArticleButtonPressed(_:)))
  }
  
  private func updateUI() {
    // TODO: refactor and setup in ArticleDetailView
    // e.g detailView.configureView(for article: article)
    guard let article = article else {
      fatalError("did not load an article")
    }
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
    guard let article = article else { return }
    do {
      // save to documents directory
      try dataPersistence.createItem(article)
    } catch {
      print("error saving article: \(error)")
    }
    
  }
  
}
