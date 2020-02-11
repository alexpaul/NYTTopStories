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
  
  // ADDITION: keep track of the bookmark
  private var bookmarkBarButton: UIBarButtonItem!
  
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
  }
  
  private func updateUI() {
    // TODO: refactor and setup in ArticleDetailView
    // e.g detailView.configureView(for article: article)
    guard let article = article else {
      fatalError("did not load an article")
    }
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
    guard let article = article else { return }
    // ADDITION: check for duplicates
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
