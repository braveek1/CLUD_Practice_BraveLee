//
//  CLUDResultTableViewCell.swift
//  CLUD_Practice_BraveLee
//
//  Created by YONGKI LEE on 2020/03/02.
//  Copyright © 2020 Brave Lee. All rights reserved.
//

import UIKit

class CRUDResultTableViewCell: UITableViewCell {

    static let nibName = String(describing: classForCoder())
    
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var ageTitle: UILabel!
    @IBOutlet weak var ageText: UILabel!
    
}
