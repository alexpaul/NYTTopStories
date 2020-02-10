//
//  SavedArticleCell.swift
//  NYTTopStories
//
//  Created by Alex Paul on 2/10/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

// step 1: custom protocol
protocol SavedArticleCellDelegate: AnyObject {
  func didSelectMoreButton(_ savedArticleCell: SavedArticleCell, article: Article)
}

class SavedArticleCell: UICollectionViewCell {
  
  // step 2: custom protocol
  weak var delegate: SavedArticleCellDelegate?
  
  // to keep track of the current cell's article
  private var currentArticle: Article!

  
  // more button
  // article title
  // news image
  public lazy var moreButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
    button.addTarget(self, action: #selector(moreButtonPressed(_:)), for: .touchUpInside)
    return button
  }()
  
  public lazy var articleTitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .title2)
    label.text = "The best headline I ever came across on NYT."
    label.numberOfLines = 0
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    setupMoreButtonConstraints()
    setupArticleTitleConstraints()
  }
  
  @objc private func moreButtonPressed(_ sender: UIButton) {
    // step 3: custom protocol
    delegate?.didSelectMoreButton(self, article: currentArticle)
  }
  
  private func setupMoreButtonConstraints() {
    addSubview(moreButton)
    moreButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      moreButton.topAnchor.constraint(equalTo: topAnchor),
      moreButton.trailingAnchor.constraint(equalTo: trailingAnchor),
      moreButton.heightAnchor.constraint(equalToConstant: 44),
      moreButton.widthAnchor.constraint(equalTo: moreButton.heightAnchor)
    ])
  }
  
  private func setupArticleTitleConstraints() {
    addSubview(articleTitle)
    articleTitle.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      articleTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
      articleTitle.trailingAnchor.constraint(equalTo: trailingAnchor),
      articleTitle.topAnchor.constraint(equalTo: moreButton.bottomAnchor),
      articleTitle.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  public func configreCell(for savedArticle: Article) {
    currentArticle = savedArticle // associating the cell with its article
    articleTitle.text = savedArticle.title
  }
}
