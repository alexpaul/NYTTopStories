//
//  NewsFeedView.swift
//  NYTTopStories
//
//  Created by Alex Paul on 2/6/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

// Added Dependency injection to view controllers

class NewsFeedView: UIView {
  
  public lazy var searchBar: UISearchBar = {
    let sb = UISearchBar()
    sb.autocapitalizationType = .none
    sb.placeholder = "search for article"
    return sb
  }()
  
  public lazy var collectionView: UICollectionView = {
    // create flow layout for collection view
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    cv.backgroundColor = .systemGroupedBackground
    return cv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: UIScreen.main.bounds)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    setupSearchBarConstraints()
    setupCollectionViewConstraints()
  }
  
  private func setupSearchBarConstraints() {
    // 1.
    addSubview(searchBar)
    
    // 2.
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    
    // 3.
    NSLayoutConstraint.activate([
      searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
      searchBar.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
  
  private func setupCollectionViewConstraints() {
    addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}
