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
  
  // properties
  private let newsFeedView = NewsFeedView()
  
  // step 2: setting up data persistence and its delegate
  // since we need an instance passed to the ArticleDetailViewController we declare a dataPersistence here
  private var dataPersistence: DataPersistence<Article>
  
  private var userPreference: UserPreference
  
  // data for our collection view
  private var newsArticles = [Article]() {
    didSet {
      DispatchQueue.main.async {
        self.newsFeedView.collectionView.reloadData()
        self.navigationItem.title = (self.newsArticles.first?.section.capitalized ?? " ") + " News"
      }
    }
  }
  
  
  private var masterArticleList = [Article]()
  
  // initializers
  init(_ dataPersistence: DataPersistence<Article>, userPreference: UserPreference) {
    self.dataPersistence = dataPersistence
    self.userPreference = userPreference
    super.init(nibName: nil, bundle: nil)
    self.userPreference.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    
    // setup search bar
    newsFeedView.searchBar.delegate = self
    
    let sectionName = userPreference.getSectionName() ?? "Technology"
    fetchStories(sectionName)
  }
  
  private func fetchStories(_ section: String) {
    NYTTopStoriesAPIClient.fetchTopStories(for: section) { [weak self] (result) in
      switch result {
      case .failure(let appError):
        print("fetching stories error: \(appError)")
      case .success(let articles):
        self?.newsArticles = articles
        self?.masterArticleList = articles
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
    let articleDVC = ArticleDetailViewController(dataPersistence, article: article)
    // after assessement we will be using initializers as dependency injection mechanisms
    
    // step 3: setting up data persistence and its delegate
    navigationController?.pushViewController(articleDVC, animated: true)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if newsFeedView.searchBar.isFirstResponder {
      newsFeedView.searchBar.resignFirstResponder()
    }
  }
}

extension NewsFeedViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard !searchText.isEmpty else {
      // if text is empty reload all the articles
      let sectionName = userPreference.getSectionName() ?? "Technology"
      fetchStories(sectionName)
      return
    }
    // filter articles based on searchText
    newsArticles = masterArticleList.filter { $0.title.lowercased().contains(searchText.lowercased()) }
  }
}

// ADDITION: conforming to UserPreferenceDelegate
extension NewsFeedViewController: UserPreferenceDelegate {
  func didChangeNewsSection(_ userPreference: UserPreference, sectionName: String) {
    fetchStories(sectionName)
  }
}
