//
//  SettingsViewController.swift
//  NYTTopStories
//
//  Created by Alex Paul on 2/6/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

struct UserKey {
  static let sectionName = "News Section"
}

class SettingsViewController: UIViewController {
  
  private let settingsView = SettingsView()
  
  // date for picker view
  private let sections = ["Arts", "Automobiles", "Books", "Business", "Fashion", "Food", "Health", "Insider", "Magazine", "Movies", "NYRegion", "Obituaries", "Opinion", "Politics", "RealeEstate", "Science", "Sports", "SundayReview", "Technology", "Theater", "T-Magazine", "Travel", "Upshot", "US", "World"]
  
  override func loadView() {
    view = settingsView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemGroupedBackground
    
    // setup picker view
    settingsView.pickerView.dataSource = self
    settingsView.pickerView.delegate = self
  }
}

extension SettingsViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return sections.count
  }
}

extension SettingsViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return sections[row] // accessing each individual string in the sections array
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    // store the current selected news section in user defaults
    let sectionName = sections[row]
    UserDefaults.standard.set(sectionName, forKey: UserKey.sectionName)
  }
}
