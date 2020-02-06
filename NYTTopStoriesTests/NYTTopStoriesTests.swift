//
//  NYTTopStoriesTests.swift
//  NYTTopStoriesTests
//
//  Created by Alex Paul on 2/6/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import XCTest
@testable import NYTTopStories

class NYTTopStoriesTests: XCTestCase {

  // unit test for our TopStory model
  func testTopStory() {
    // arrange
    let jsonData = """
        {
          "status": "OK",
          "copyright": "Copyright (c) 2020 The New York Times Company. All Rights Reserved.",
          "section": "New York",
          "last_updated": "2020-02-06T09:54:31-05:00",
          "num_results": 33,
          "results": [{
            "section": "us",
            "subsection": "politics",
            "title": "Trump Administration Freezes Global Entry Enrollment in New York Over Immigration Law",
            "abstract": "The move escalates a clash between the administration and the state over a law that allows undocumented immigrants to obtain driver’s licenses.",
            "url": "https://www.nytimes.com/2020/02/06/us/politics/dhs-new-york-global-entry.html",
            "uri": "nyt://article/23fb8409-46f1-5f0f-b663-afc9f8eaf0bb",
            "byline": "By Zolan Kanno-Youngs and Jesse McKinley",
            "item_type": "Article",
            "updated_date": "2020-02-06T08:56:55-05:00",
            "created_date": "2020-02-06T00:12:30-05:00",
            "published_date": "2020-02-06T00:12:30-05:00",
            "material_type_facet": "",
            "kicker": "",
            "des_facet": [
              "Immigration and Emigration",
              "Illegal Immigration"
            ],
            "org_facet": [
              "Homeland Security Department"
            ],
            "per_facet": [
              "Cuomo, Andrew M",
              "Trump, Donald J"
            ],
            "geo_facet": [
              "New York State"
            ],
            "multimedia": [{
                "url": "https://static01.nyt.com/images/2020/02/05/briefing/05dc-DHS-entry/merlin_53911875_652526bb-a36e-461d-8d79-33d961b39c6e-superJumbo.jpg",
                "format": "superJumbo",
                "height": 1365,
                "width": 2048,
                "type": "image",
                "subtype": "photo",
                "caption": "Enrollment in Global Entry and several other expedited-travel programs has been suspended for all residents of New York State in a bid to force local authorities to submit to directives by the Department of Homeland Security.",
                "copyright": "Marilynn K. Yee/The New York Times"
              },
              {
                "url": "https://static01.nyt.com/images/2020/02/05/briefing/05dc-DHS-entry/05dc-DHS-entry-thumbStandard.jpg",
                "format": "Standard Thumbnail",
                "height": 75,
                "width": 75,
                "type": "image",
                "subtype": "photo",
                "caption": "Enrollment in Global Entry and several other expedited-travel programs has been suspended for all residents of New York State in a bid to force local authorities to submit to directives by the Department of Homeland Security.",
                "copyright": "Marilynn K. Yee/The New York Times"
              },
              {
                "url": "https://static01.nyt.com/images/2020/02/05/briefing/05dc-DHS-entry/05dc-DHS-entry-thumbLarge.jpg",
                "format": "thumbLarge",
                "height": 150,
                "width": 150,
                "type": "image",
                "subtype": "photo",
                "caption": "Enrollment in Global Entry and several other expedited-travel programs has been suspended for all residents of New York State in a bid to force local authorities to submit to directives by the Department of Homeland Security.",
                "copyright": "Marilynn K. Yee/The New York Times"
              },
              {
                "url": "https://static01.nyt.com/images/2020/02/05/briefing/05dc-DHS-entry/merlin_53911875_652526bb-a36e-461d-8d79-33d961b39c6e-mediumThreeByTwo210.jpg",
                "format": "mediumThreeByTwo210",
                "height": 140,
                "width": 210,
                "type": "image",
                "subtype": "photo",
                "caption": "Enrollment in Global Entry and several other expedited-travel programs has been suspended for all residents of New York State in a bid to force local authorities to submit to directives by the Department of Homeland Security.",
                "copyright": "Marilynn K. Yee/The New York Times"
              },
              {
                "url": "https://static01.nyt.com/images/2020/02/05/briefing/05dc-DHS-entry/merlin_53911875_652526bb-a36e-461d-8d79-33d961b39c6e-articleInline.jpg",
                "format": "Normal",
                "height": 127,
                "width": 190,
                "type": "image",
                "subtype": "photo",
                "caption": "Enrollment in Global Entry and several other expedited-travel programs has been suspended for all residents of New York State in a bid to force local authorities to submit to directives by the Department of Homeland Security.",
                "copyright": "Marilynn K. Yee/The New York Times"
              }
            ],
            "short_url": "https://nyti.ms/371T1wX"
          }]
        }
    """.data(using: .utf8)!
    
    let expectedTitle = "Trump Administration Freezes Global Entry Enrollment in New York Over Immigration Law"
    
    // act
    do {
      let topStories = try JSONDecoder().decode(TopStories.self, from: jsonData)
      // assert
      let supTitle = topStories.results.first?.title ?? ""
      XCTAssertEqual(expectedTitle, supTitle)
    } catch {
      XCTFail("decoding error: \(error)")
    }
  }

}
