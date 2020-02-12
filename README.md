# NYTTopStories

App review to demonstrate the following: collection view, custom delegation, persistence using UserDefaults and Documents directory, setting up UI Programmatically, animaation and gestures.

- [x] Collection view 
- [x] Custom pogrammatic collection view cell
- [x] User defaults 
- [x] Search
- [x] Subclass UITabBarController
- [x] FileManager and documents directory 
- [x] Custom delegation 
- [x] Programmatic UI 
- [x] Segueing view controllers in code 
- [x] Animations 
- [x] Gestures
- [x] Unit test

## Running this project 

In order to run this project you will need an API key to access the [New York Times Top Stories API](https://developer.nytimes.com/docs/top-stories-product/1/overview). Once you've registered and acquired an API key, do the following: 

1. Clone this repo
2. Open the Xcode project and navigate to **Supporting Files** folder delete the Config.swift file and create a new Config.swift file
3. Open the newly created Config.swift file and enter the following code below: 

```swift 
struct Config {
  static let apiKey = "YOUR API KEY FOR THE NEW YORK TIMES TOP STORIES API GOES HERE"
}
```

4. Run the project 

## Encapsulatinng our view controller properties, using dependency injection with designated initializers

```swift 
private var dataPersistence: DataPersistence<Article>
private var userPreference: UserPreference

init(_ dataPersistence: DataPersistence<Article>, userPreference: UserPreference) {
  self.userPreference = userPreference
  self.userPreference.delegate = self
  self.dataPersistence = dataPersistence
  super.init(nibName: nil, bundle: nil)
}

required init?(coder: NSCoder) {
  fatalError("init(coder:) has not been implemented")
}
```

![news-feed](Assets/news-feed.png)
