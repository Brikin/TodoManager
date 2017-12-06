//
//  TaskCell.swift
//  ToDoList
//
//  Created by Ruslan on 28/11/2017.
//  Copyright © 2017 Ruslan. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    weak var parentTableController: TasksListTableController?
    var task: Task?
    
    @IBOutlet weak var nameTaskLabel: UILabel!
    
    
    @IBOutlet weak var dateTaskLabel: UILabel!
    @IBOutlet weak var checkBox: CCheckbox!
 
    
    @IBAction func checkBoxOneButton(_ sender: UIButton) {
        guard let task = self.task else { return }
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.parentTableController?.complete(task: task)
        }
    }
}

extension TaskCell: CheckboxDelegate {
    
    func didSelect(_ checkbox: CCheckbox) {
        switch checkbox {
        case checkBox:
            checkBox.animation = .showHideTransitionViews
            print("checkbox one selected")
            break
        default:
            break
        }
    }
    
    func didDeselect(_ checkbox: CCheckbox) {
        switch checkbox {
        case checkBox:
            print("checkbox one deselected")
            break
        default:
            break
        }
    }
}

