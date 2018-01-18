//
//  DateComponentsFormatter+Helper.swift
//  360player
//
//  Created by William Hass on 11/28/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation

@objc(TimeIntervalHelper) class TimeIntervalHelper: NSObject {
    @objc static func timeVideoDurationString(fromTimeInterval: TimeInterval) -> String? {
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.positional
        if fromTimeInterval > 60 * 60 {
            dateComponentsFormatter.allowedUnits = [NSCalendar.Unit.hour,NSCalendar.Unit.minute, NSCalendar.Unit.second]
        } else {
            dateComponentsFormatter.allowedUnits = [NSCalendar.Unit.minute, NSCalendar.Unit.second]
        }
        dateComponentsFormatter.zeroFormattingBehavior = DateComponentsFormatter.ZeroFormattingBehavior.pad
        return dateComponentsFormatter.string(from: fromTimeInterval)
    }
}
