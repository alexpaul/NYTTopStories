//
//  SavedArticleViewController.swift
//  NYTTopStories
//
//  Created by Alex Paul on 2/6/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import DataPersistence

class SavedArticleViewController: UIViewController {
  
  // step 4: setting up data persistence and its delegate
  public var dataPersistence: DataPersistence<Article>!
  
  // TODO: create a SavedArticleView
  // TODO: add a collection view to the SavedArticleView
  // TODO: collection view is vertical with 2 cells per row
  // TODO: add SavedArticleView to SavedArticleViewController
  // TODO: create an array of savedArticle = [Article]
  // TODO: reload collection view in didSet of savedArticle array
  
  private var savedArticles = [Article]() {
    didSet {
      print("there are \(savedArticles.count) articles")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    dataPersistence.delegate = self
    fetchSavedArticles()
  }
  
  private func fetchSavedArticles() {
    do {
      savedArticles = try dataPersistence.loadItems()
    } catch {
      print("error fetching articles: \(error)")
    }
  }
}

// step 5: setting up data persistence and its delegate
// conforming to the DataPersistenceDelegate
extension SavedArticleViewController: DataPersistenceDelegate {
  func didSaveItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
    print("ites was saved")
    fetchSavedArticles()
  }
  
  func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
    print("ites was deleted")
  }
}
