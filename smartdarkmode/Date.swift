//
//  Date.swift
//  smartdarkmode
//
//  Created by Michael Zhou on 2018-12-03.
//  Copyright © 2018 Michael Zhou. All rights reserved.
//

import Foundation

extension Date {
    func convertToLocalTime() -> Date {
        let localOffeset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: self))
        return self.addingTimeInterval(localOffeset)
    }
}
