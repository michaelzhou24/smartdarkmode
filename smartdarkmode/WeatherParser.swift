//
//  WeatherParser.swift
//  smartdarkmode
//
//  Created by Michael Zhou on 2018-10-21.
//  Copyright © 2018 Michael Zhou. All rights reserved.
//

import Foundation

func getURL(lat: Double, lon: Double) -> String {
    return "https://api.sunrise-sunset.org/json?lat=\(lat)&lng=\(lon)&date=today&formatted=0"
}

func getSunriseSunset(lat: Double, lon: Double) -> [Date] {
    var dates = [Date]()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    guard let url = URL(string: getURL(lat: lat, lon: lon)) else {return []}
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let dataResponse = data,
            error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return }
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with:
                dataResponse, options: [])
            print(jsonResponse)
            if let dictionary = jsonResponse as? [String: Any] {
                if let nestedDictionary = dictionary["results"] as? [String: Any] {
                    if let sunrise = nestedDictionary["sunrise"] as? String {
                        dates.append(dateFormatter.date(from: sunrise)!)
                    }
                    if let sunset = nestedDictionary["sunset"] as? String {
                        dates.append(dateFormatter.date(from: sunset)!)
                    }
                }
            }
            
        } catch let parsingError {
            print("Error", parsingError)
        }
    }
    task.resume()
    while dates.count != 2 {}
    return dates
}
