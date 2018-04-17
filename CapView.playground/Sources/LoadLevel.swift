//
//  LoadLevel.swift
//
//  Created by Sven A. Schmidt <sas@finestructure.co>
//

import UIKit


public enum LoadLevel: Int {
    case Level0 = 0
    case Level1
    case Level2
    case Level3
    case Level4
    case Level5

    init?(value: Double?) {
        if let v = value {
            let low = 0.1
            let high = 0.9
            if v < low {
                self.init(rawValue: 0)
            } else if v >= high {
                self.init(rawValue: 5)
            } else {
                let binWidth = (high - low)/4
                self.init(rawValue: Int((v - low)/binWidth)+1)
            }
        } else {
            return nil
        }
    }

    static func color(load: Double) -> UIColor {
        let p = load > 1.0 ? 0 : (1 - load)*100
        let hue = CGFloat(p / 360)
        return UIColor(hue: hue, saturation: 0.7, brightness: 1.0, alpha: 1.0)
    }

}

