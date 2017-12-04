//
//  CompletedCell.swift
//  ToDoList
//
//  Created by Ruslan on 04/12/2017.
//  Copyright © 2017 Ruslan. All rights reserved.
//

import UIKit

class CompletedCell: UITableViewCell {
    weak var parentTableController: TasksListTableController?
    var task: Task?
    
    @IBOutlet weak var nameTaskLabel: UILabel!
    
    @IBOutlet weak var dateTaskLabel: UILabel!
    @IBOutlet weak var checkBox: CCheckbox!
    
    
    @IBAction func checkBoxOneButton(_ sender: UIButton) {
        guard let task = self.task else { return }
     //   parentTableController?.complete(task: task)
    }
    
    
}
