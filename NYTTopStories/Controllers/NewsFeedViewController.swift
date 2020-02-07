//
//  NewsFeedViewController.swift
//  NYTTopStories
//
//  Created by Alex Paul on 2/6/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import DataPersistence

class NewsFeedViewController: UIViewController {
  
  private let newsFeedView = NewsFeedView()
  
  // step 2: setting up data persistence and its delegate
  // since we need an instance passed to the ArticleDetailViewController we declare a dataPersistence here
  public var dataPersistence: DataPersistence<Article>!
  
  // data for our collection view
  private var newsArticles = [Article]() {
    didSet {
      DispatchQueue.main.async {
        self.newsFeedView.collectionView.reloadData()
      }
    }
  }
  
  override func loadView() {
    view = newsFeedView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground // white when dark mode is off, black when dark mode is on
    
    // setting up collection datasource and delegate
    newsFeedView.collectionView.dataSource = self
    newsFeedView.collectionView.delegate = self
    
    // register a collection view cell
    newsFeedView.collectionView.register(NewsCell.self, forCellWithReuseIdentifier: "articleCell")
    
    fetchStories()
  }
  
  private func fetchStories(for section: String = "Technology") {
    NYTTopStoriesAPIClient.fetchTopStories(for: section) { [weak self] (result) in
      switch result {
      case .failure(let appError):
        print("error fetching stories: \(appError)")
      case .success(let articles):
        self?.newsArticles = articles
      }
    }
  }
}

extension NewsFeedViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return newsArticles.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as? NewsCell else {
      fatalError("could not downcast to NewsCell")
    }
    let article = newsArticles[indexPath.row]
    cell.configureCell(with: article)
    cell.backgroundColor = .systemBackground
    return cell
  }
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
  // return item size
  // itemHeight ~ 30% of height of device
  // itemWidth = 100% of width of device
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let maxSize: CGSize = UIScreen.main.bounds.size
    let itemWidth: CGFloat = maxSize.width
    let itemHeight: CGFloat = maxSize.height * 0.20 // 30%
    return CGSize(width: itemWidth, height: itemHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let article = newsArticles[indexPath.row]
    let articleDVC = ArticleDetailViewController()
    // TODO: after assessement we will be using initializers as dependency injection mechanisms
    articleDVC.article = article
    
    // step 3: setting up data persistence and its delegate
    articleDVC.dataPersistence = dataPersistence
    navigationController?.pushViewController(articleDVC, animated: true)
  }
}
