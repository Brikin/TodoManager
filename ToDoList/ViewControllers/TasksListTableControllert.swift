//
//  ItemsList.swift
//  ToDoList
//
//  Created by Ruslan on 28/11/2017.
//  Copyright © 2017 Ruslan. All rights reserved.
//

import UIKit

class TasksListTableController: UIViewController {
    
    var taskStore: TaskStore! {
        get { return (UIApplication.shared.delegate as? AppDelegate)?.taskStore }
    }
    
    var tasksDetailsController: TasksDetailsController!

    
    var listIdentifier = ""
    
    var sectionsTitle: [String] = []
    var taskInSection: [[Task]] = []
    
    var overdue: [Task] = []
    var today: [Task] = []
    var tomorrow: [Task] = []
    var nextWeek: [Task] = []
    var completed: [Task] = []
    
    
    
    override func viewDidLoad() {
       // super.viewDidLoad()
        self.navigationController?.title = listIdentifier
        let sortByList = taskStore.taskForList(listName: "\(listIdentifier)")
        sortBySections(list: sortByList)
    }
    
    func sortBySections(list: [Task])  {
        overdue = taskStore.taskForDate(list: list, dateDue: Date(), range: "overdue")
        if !overdue.isEmpty  {
            sectionsTitle.append("OVERDUE")
            taskInSection.append(overdue)
        }
        
        today = taskStore.taskForDate(list: list, dateDue: Date(), range: "today")
        if !today.isEmpty  {
            sectionsTitle.append("TODAY")
            taskInSection.append(today)
        }
        
        tomorrow = taskStore.taskForDate(list: list, dateDue: Date(), range: "tomorrow")
        if !tomorrow.isEmpty  {
            sectionsTitle.append("TOMORROW")
            taskInSection.append(tomorrow)
        }
        
        nextWeek = taskStore.taskForDate(list: list, dateDue: Date(), range: "week")
        if !nextWeek.isEmpty  {
            sectionsTitle.append("Next seven days")
            taskInSection.append(nextWeek)
        }
        
        completed = taskStore.taskForComplete(status: true)
        if !completed.isEmpty  {
            sectionsTitle.append("Completed")
            taskInSection.append(completed)
        }
    tableTask.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // tasksDetailsController = segue.destination as? TasksDetailsController

      //  if (segue.identifier == "Details") {
   //     }
    }
    
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var tableTask: UITableView!
    
    @IBAction func addTaskButtonTapped(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = true
        textField.becomeFirstResponder()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let _ = taskStore.createTask(name: textField.text!, list: "\(String(describing: self.navigationController?.title))")
        textField.text = nil
        textField.isEnabled = false
        
    }
    
    
}

extension TasksListTableController: UITableViewDelegate {
    
}

extension TasksListTableController: UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.nameTaskLabel.text = self.taskInSection[section][row].name
        cell.dateTaskLabel.text = DateFormatter.localizedString(from: taskInSection[section][row].date,
                                                                dateStyle: DateFormatter.Style(rawValue: 2)!,
                                                                timeStyle: DateFormatter.Style(rawValue: 0)!)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionsTitle[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionsTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskInSection[section].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! TaskCell
        let labelContent = cell.nameTaskLabel.text
        NSLog("You selected cell number: \(indexPath.row)!")
    }
}
