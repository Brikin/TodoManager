//
//  TaskCell.swift
//  ToDoList
//
//  Created by Ruslan on 28/11/2017.
//  Copyright © 2017 Ruslan. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var countOverdue: UILabel!
    @IBOutlet weak var currentCount: UILabel!
    @IBOutlet weak var imageOverdue: UIImageView!
}


