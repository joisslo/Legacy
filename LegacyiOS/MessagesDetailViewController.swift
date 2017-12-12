//
//  MessagesDetailViewController.swift
//  CollegeIOS
//
//  Created by Joseph Rudeseal on 12/7/17.
//  Copyright © 2017 Jerry Hill. All rights reserved.
//

import Foundation
import UIKit

class MessagesDetailViewController : UIViewController {
    
    var message : DTO_Message?
    var userPhoto : UIImage?
    
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var ivUserPhoto: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvMessage.text = message?.message
        ivUserPhoto.image = userPhoto
        lblName.text = message?.authorName
        lblTitle.text = message?.title
        
    }
}
