//
//  Helpers.swift
//  CollegeIOS
//
//  Created by Joseph Rudeseal on 11/15/17.
//  Copyright © 2017 Jerry Hill. All rights reserved.
//

import Foundation
import UIKit

func getRandomUserPicture() -> UIImage {
    let rand = Int(arc4random_uniform(8))
    var user: UIImage
    if rand == 0 {
        user = #imageLiteral(resourceName: "Group 333.png").circleMasked!
    } else if rand == 1 {
        user = #imageLiteral(resourceName: "Group 325.png").circleMasked!
    } else if rand == 2 {
        user = #imageLiteral(resourceName: "Group 326.png").circleMasked!
    } else if rand == 3 {
        user = #imageLiteral(resourceName: "Group 328.png").circleMasked!
    } else if rand == 4 {
        user = #imageLiteral(resourceName: "Group 329.png").circleMasked!
    } else if rand == 5 {
        user = #imageLiteral(resourceName: "Group 330.png").circleMasked!
    } else if rand == 6 {
        user = #imageLiteral(resourceName: "Group 331.png").circleMasked!
    } else {
        user = #imageLiteral(resourceName: "Group 332.png").circleMasked!
    }
    return user
}
