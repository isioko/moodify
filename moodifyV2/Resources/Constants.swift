//
//  Constants.swift
//  moodifyV2
//
//  Created by Ashi Agrawal on 2/20/19.
//  Copyright © 2019 Isi Okojie. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    struct Colors {
        static let pinkColor = UIColor(red: 250/225, green: 104/225, blue: 104/225, alpha: 1).cgColor
        static let purpleColor = UIColor(red: 179/225, green: 102/225, blue: 225/225, alpha: 1).cgColor
        static let blueColor = UIColor(red: 85/225, green: 127/225, blue: 242/225, alpha: 1).cgColor
    }
    static func themeColors() -> Array<CGColor> {
        return [Colors.pinkColor, Colors.purpleColor, Colors.blueColor]
    }
}
