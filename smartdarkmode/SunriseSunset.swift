//
//  SunriseSunset.swift
//  smartdarkmode
//
//  Created by Michael Zhou on 2018-11-09.
//  Copyright © 2018 Michael Zhou. All rights reserved.
//

import Foundation

struct Blog: Decodable {
    let title: String
    let homepageURL: URL
    
    enum CodingKeys : String, CodingKey {
        case title
        case homepageURL = "home_page_url"
    }
}
