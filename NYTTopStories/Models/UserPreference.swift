//
//  UserPreference.swift
//  NYTTopStories
//
//  Created by Alex Paul on 2/10/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation

// ADDITION: created a UserPreference class and UserPreferenceDelegate to update and listen to changes
// on UserDefaults
// this way we do not have to always call viewWillAppear() to check and reload our fetchStories()


struct UserKey {
  static let sectionName = "News Section"
}

protocol UserPreferenceDelegate: AnyObject {
  func didChangeNewsSection(_ userPreference: UserPreference, sectionName: String)
}

final class UserPreference {
  weak var delegate: UserPreferenceDelegate?
  
  public func getSectionName() -> String? {
    return UserDefaults.standard.object(forKey: UserKey.sectionName) as? String
  }
  
  public func setSectionName(_ sectionName: String) {
    UserDefaults.standard.set(sectionName, forKey: UserKey.sectionName)
    delegate?.didChangeNewsSection(self, sectionName: sectionName)
  }
}
