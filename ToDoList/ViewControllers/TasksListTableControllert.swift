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
    var selectedTask: Task!
    
    var overdue: [Task] = []
    var today: [Task] = []
    var tomorrow: [Task] = []
    var nextWeek: [Task] = []
    var completed: [Task] = []
    
    
    
    override func viewDidLoad() {
        

        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.title = ""
  
        self.navigationItem.title = listIdentifier
        let sortByList = taskStore.taskForList(listName: "\(listIdentifier)")
        sortBySections(list: sortByList)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // tasksDetailsController = segue.destination as? TasksDetailsController
        
        //  if (segue.identifier == "Details") {
        //     }
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableTask: UITableView!
    @IBOutlet weak var toolbarView: UIToolbar!
    @IBOutlet weak var tabBarView: UITabBar!
    @IBOutlet weak var tabBarToday: UITabBarItem!
    @IBOutlet weak var tabBarTomorrow: UITabBarItem!
    @IBOutlet weak var tabBarWeek: UITabBarItem!
    
    @IBOutlet weak var doneButtonForTabBar: UIBarButtonItem!
    
    @IBAction func dateToday(_ sender: Any) {
        selectedTask.date = Date()
        tableTask.reloadData()
    }
    
    
    @IBAction func dateTomorrow(_ sender: Any) {
        guard let selectedTask = self.selectedTask else { return }
        self.selectedTask.date = taskStore.changeDate(date: selectedTask.date, value: "tomorrow")
        tableTask.reloadData()
    }
    
    
    @IBAction func dateWeek(_ sender: Any) {
        guard let selectedTask = self.selectedTask else { return }
        self.selectedTask.date = taskStore.changeDate(date: selectedTask.date, value: "week")
        tableTask.reloadData()
    }
    
    
    
    @IBAction func doneTabBar(_ sender: Any) {
        tabBarView.isHidden = true
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.title = ""
    }
    
    @IBAction func addTaskButtonTapped(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = true
        textField.becomeFirstResponder()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let _ = taskStore.createTask(name: textField.text!, list: "\(self.navigationItem.title!)")
        textField.text = nil
        textField.isEnabled = false
        self.navigationController?.isNavigationBarHidden = false
        tableTask.reloadData()
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
//        sectionsTitle.append("")
//        taskInSection.append([Task]())
        tableTask.reloadData()
    }
    
}

extension TasksListTableController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBarToday {
            selectedTask.date = Date()
            tableTask.reloadData()
        } else if item == tabBarTomorrow {
            guard let selectedTask = self.selectedTask else { return }
            self.selectedTask.date = taskStore.changeDate(date: selectedTask.date, value: "tomorrow")
            tableTask.reloadData()
        } else if item == tabBarWeek {
            guard let selectedTask = self.selectedTask else { return }
            self.selectedTask.date = taskStore.changeDate(date: selectedTask.date, value: "week")
            tableTask.reloadData()
        }
        
    }
    
}

extension TasksListTableController: UITableViewDelegate {
    
}

extension TasksListTableController: UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
//        if  section != self.sectionsTitle.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            cell.nameTaskLabel.text = self.taskInSection[section][row].name
            cell.dateTaskLabel.text = DateFormatter.localizedString(from: taskInSection[section][row].date,
                                                                    dateStyle: DateFormatter.Style(rawValue: 2)!,
                                                                    timeStyle: DateFormatter.Style(rawValue: 0)!)
            return cell
            
//        }
        
//        let cellButton = tableView.dequeueReusableCell(withIdentifier: "ShowCompletedCell", for: indexPath) as! ShowCompletedCell
//        return cellButton
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionsTitle[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionsTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if sectionsTitle == [""] {
//            return self.taskInSection[section].count + 1
//        }
        
        return self.taskInSection[section].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = indexPath.section
        let row = indexPath.row
        
        selectedTask = taskInSection[section][row]
        
        
        let cell = tableView.cellForRow(at: indexPath) as! TaskCell
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(TasksListTableController.longTap))
         cell.addGestureRecognizer(longGesture)
        let labelContent = cell.nameTaskLabel.text
        NSLog("You selected cell number: \(indexPath.row)!")
    }
    
    @objc func longTap(gestureReconizer: UILongPressGestureRecognizer) {
        
        print("Long tap")
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.title = "Done"
        
        let longPress = gestureReconizer as UILongPressGestureRecognizer
        _ = longPress.state
        let locationInView = longPress.location(in: tableTask)
        let indexPath = tableTask.indexPathForRow(at: locationInView)
        tabBarView.isHidden = false
        // whatever you want with indexPath use it //
        
    }
    
    
    
    
    
    
    
    
}
