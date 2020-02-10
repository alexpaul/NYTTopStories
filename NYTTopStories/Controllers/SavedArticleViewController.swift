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
  
  private let savedArticleView = SavedArticleView()
  
  // step 4: setting up data persistence and its delegate
  public var dataPersistence: DataPersistence<Article>!
  
  // TODO: collection view is vertical with 2 cells per row
  // TODO: reload collection view in didSet of savedArticle array
  
  private var savedArticles = [Article]() {
    didSet {
      savedArticleView.collectionView.reloadData()
      if savedArticles.isEmpty {
        // setup our empty view on the collection view background view
        savedArticleView.collectionView.backgroundView = EmptyView(title: "Saved Articles", message: "There are currently no saved articles. Start browsing by tapping on the News icon.")
      } else {
        // remove empty view from collection view background view
        savedArticleView.collectionView.backgroundView = nil
      }
    }
  }
  
  override func loadView() {
    view = savedArticleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    fetchSavedArticles()
    
    // setup collection view
    savedArticleView.collectionView.dataSource = self
    savedArticleView.collectionView.delegate = self
    
    // register cell
    savedArticleView.collectionView.register(SavedArticleCell.self, forCellWithReuseIdentifier: "savedArticleCell")
  }
  
  private func fetchSavedArticles() {
    do {
      savedArticles = try dataPersistence.loadItems()
    } catch {
      print("error fetching articles: \(error)")
    }
  }
}

extension SavedArticleViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return savedArticles.count
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedArticleCell", for: indexPath) as? SavedArticleCell else {
      fatalError("could not downcast to a SavedArticleCell")
    }
    let savedArticle = savedArticles[indexPath.row]
    cell.backgroundColor = .white
    cell.configreCell(for: savedArticle)
    // step 1: registering as the delegate object
    cell.delegate = self
    return cell
  }
}

extension SavedArticleViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let maxSize: CGSize = UIScreen.main.bounds.size
    let spacingBetweenItems: CGFloat = 10
    let numberOfItems: CGFloat = 2
    let itemHeight: CGFloat = maxSize.height * 0.30
    let totalSpacing: CGFloat = (2 * spacingBetweenItems) + (numberOfItems - 1) * spacingBetweenItems
    let itemWidth: CGFloat = (maxSize.width - totalSpacing) / numberOfItems
    return CGSize(width: itemWidth, height: itemHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  }
  
}

// step 5: setting up data persistence and its delegate
// conforming to the DataPersistenceDelegate
extension SavedArticleViewController: DataPersistenceDelegate {
  func didSaveItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
    fetchSavedArticles()
  }
  
  func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
    print("ites was deleted")
  }
}

// step 2: registering as the delegate object
extension SavedArticleViewController: SavedArticleCellDelegate {
  func didSelectMoreButton(_ savedArticleCell: SavedArticleCell, article: Article) {
    print("didSelectMoreButton: \(article.title)")
    // create an action sheet
    // cancel action
    // delete action
    // post MVP shareAction
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { alertAction in
      // TODO: write a delete helper function
    }
    alertController.addAction(cancelAction)
    alertController.addAction(deleteAction)
    present(alertController, animated: true)
  }
}
