//
//  ShowCompletedCell.swift
//  ToDoList
//
//  Created by Ruslan on 29/11/2017.
//  Copyright © 2017 Ruslan. All rights reserved.
//

import UIKit

class ShowCompletedCell: UITableViewCell {
   
    var parentTableController: TasksListTableController?
    
    
    @IBOutlet weak var buttonShow: UIButton!
    @IBAction func buttonShowTap(_ sender: Any) {
        
        parentTableController?.showSectionIndicator = 1
        parentTableController?.refresh()
    }
}
