//
//  SettingsViewController.swift
//  NYTTopStories
//
//  Created by Alex Paul on 2/6/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
  
  private let settingsView = SettingsView()
  
  // date for picker view
  private let sections = ["Arts", "Automobiles", "Books", "Business", "Fashion", "Food", "Health", "Insider", "Magazine", "Movies", "NYRegion", "Obituaries", "Opinion", "Politics", "RealeEstate", "Science", "Sports", "SundayReview", "Technology", "Theater", "T-Magazine", "Travel", "Upshot", "US", "World"]
  
  public var userPreference: UserPreference!

  override func loadView() {
    view = settingsView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemGroupedBackground
    
    // setup picker view
    settingsView.pickerView.dataSource = self
    settingsView.pickerView.delegate = self
    
    // ADDITION: scroll to picker view's index if there is a section saved in UserDefaults
    if let sectionName = userPreference.getSectionName() {
      if let index = sections.firstIndex(of: sectionName) {
        settingsView.pickerView.selectRow(index, inComponent: 0, animated: true)
      }
    }
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
    userPreference.setSectionName(sectionName)
  }
}


