//
//  ItemsList.swift
//  ToDoList
//
//  Created by Ruslan on 28/11/2017.
//  Copyright © 2017 Ruslan. All rights reserved.
//

import UIKit
import Foundation

class TasksListTableController: UIViewController {
    
    var taskStore: TaskStore! {
        get { return (UIApplication.shared.delegate as? AppDelegate)?.taskStore }
    }
    
    var tasksDetailsController: TasksDetailsController!
    var showComplete: ShowCompletedCell!
    
    var shownIndexes : [IndexPath] = []
    
    var listIdentifier = ""
    
    var sectionsTitle: [String] = []
    var taskInSection: [[Task]] = []
    var selectedTask: Task!
    
    var showSectionIndicator = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if showSectionIndicator == 1 {
            showComplete.buttonShow.isEnabled = false
        }
      
        
        self.navigationItem.title = listIdentifier
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        refresh()
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
    
    @IBAction func doneTabBar(_ sender: Any) {
        tabBarView.isHidden = true
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.title = ""
    }
    
    @IBAction func addTaskButtonTapped(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = true
        textField.isEnabled = true
        textField.becomeFirstResponder()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let _ = taskStore.createTask(name: textField.text!, list: "\(self.navigationItem.title!)")
        textField.text = nil
        textField.isEnabled = false
        self.navigationController?.isNavigationBarHidden = false
        self.refresh()
    }
    
    func sortBySections(list: [Task])  {
        
        let overdue = taskStore.taskForDate(list: list, dateDue: Date(), range: .overdue)
        if !overdue.isEmpty  {
            sectionsTitle.append("OVERDUE")
            taskInSection.append(overdue)
        }
        
        let today = taskStore.taskForDate(list: list, dateDue: Date(), range: .today)
        if !today.isEmpty  {
            sectionsTitle.append("TODAY")
            taskInSection.append(today)
        }
        
        let tomorrow = taskStore.taskForDate(list: list, dateDue: Date(), range: .tomorrow)
        if !tomorrow.isEmpty  {
            sectionsTitle.append("TOMORROW")
            taskInSection.append(tomorrow)
        }
        
        let nextWeek = taskStore.taskForDate(list: list, dateDue: Date(), range: .week)
        if !nextWeek.isEmpty  {
            sectionsTitle.append("Next seven days")
            taskInSection.append(nextWeek)
        }
        
        let completed = taskStore.taskForComplete(list: list, status: true)
        if !completed.isEmpty && showSectionIndicator != 0  {
            sectionsTitle.append("Completed")
            taskInSection.append(completed)
        }
    }
    
    func refresh() {
        sectionsTitle = []
        taskInSection = []
        let sortByList = taskStore.taskForList(listName: "\(listIdentifier)")
        sortBySections(list: sortByList)
        self.tableTask.reloadData()
    }
    
    func complete(task: Task) {
        task.complete = true
        self.refresh()
    }
}

extension TasksListTableController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBarToday {
            selectedTask.date = Date()
            
        } else if item == tabBarTomorrow {
            guard let selectedTask = self.selectedTask else { return }
            self.selectedTask.date = taskStore.changeDate(date: selectedTask.date, value: "tomorrow")
            
        } else if item == tabBarWeek {
            guard let selectedTask = self.selectedTask else { return }
            self.selectedTask.date = taskStore.changeDate(date: selectedTask.date, value: "week")
        }
        refresh()
    }
}

extension TasksListTableController: UITableViewDelegate {
    
}

extension TasksListTableController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let cellButton = tableView.dequeueReusableCell(withIdentifier: "ShowCompletedCell", for: indexPath) as! ShowCompletedCell
        let completedCell = tableView.dequeueReusableCell(withIdentifier: "CompletedCell", for: indexPath) as! CompletedCell
        cellButton.parentTableController = self
        completedCell.parentTableController = self
        cell.parentTableController = self
        completedCell.checkBox.animation = .transitionCrossDissolve

        if  (section == self.sectionsTitle.count - 1 && row == self.taskInSection[section].count) || self.sectionsTitle.count == 0 {
            
            if showSectionIndicator == 1 {
                cellButton.buttonShow.isEnabled = false
                cellButton.buttonShow.setTitle("No more completed", for: .disabled)
            }
            
            return cellButton
        }
        
        if sectionsTitle[section] == "Completed"  {
            completedCell.nameTaskLabel.text = self.taskInSection[section][row].name
            completedCell.dateTaskLabel.text = DateFormatter.localizedString(from: taskInSection[section][row].date,
                                                                             dateStyle: DateFormatter.Style(rawValue: 2)!,
                                                                             timeStyle: DateFormatter.Style(rawValue: 0)!)
            return completedCell
        }
        
      //  cellButton.buttonShow
        //completedCell.checkBox.delegate = completedCell
        cell.checkBox.animation = .transitionCrossDissolve
        cell.checkBox.delegate = cell
        cell.task = taskInSection[section][row]
        cell.nameTaskLabel.text = self.taskInSection[section][row].name
        cell.dateTaskLabel.text = DateFormatter.localizedString(from: taskInSection[section][row].date,
                                                                dateStyle: DateFormatter.Style(rawValue: 2)!,
                                                                timeStyle: DateFormatter.Style(rawValue: 0)!)
        return cell
    }
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.sectionsTitle.count == 0 {
            ///header color
        }
        
        if (shownIndexes.contains(indexPath) == false) {
            shownIndexes.append(indexPath)
            
            cell.transform = CGAffineTransform(translationX: 0, y: 3)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 10, height: 10)
            cell.alpha = 0
            
            UIView.beginAnimations("rotation", context: nil)
            UIView.setAnimationDuration(0.5)
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.alpha = 1
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            UIView.commitAnimations()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let aHeader = UITableViewHeaderFooterView()
        let header = aHeader as UIView
        var headerFrame = tableView.frame
        headerFrame.size.height = 100
        header.frame = headerFrame
        
        let transition = CATransition()
        transition.duration = 1.0;
        transition.type = kCATransitionReveal; //choose your animation
        header.layer.add(transition, forKey: nil)
        return header

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.sectionsTitle.count == 0 {
            return ""
        }
        return self.sectionsTitle[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.sectionsTitle.count == 0 {
            return 1
        }
        return self.sectionsTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.sectionsTitle.count == 0 {
            return 1
        }
        if section == self.sectionsTitle.count - 1 {
            return self.taskInSection[section].count + 1
        }
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
        //  let labelContent = cell.nameTaskLabel.text
        NSLog("You selected cell number: \(indexPath.row)!")
    }
    
    @objc func longTap(gestureReconizer: UILongPressGestureRecognizer) {
        
        print("Long tap")
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.title = "Done"
        
        let longPress = gestureReconizer as UILongPressGestureRecognizer
        _ = longPress.state
        //let locationInView = longPress.location(in: tableTask)
        //  let indexPath = tableTask.indexPathForRow(at: locationInView)
        tabBarView.isHidden = false
        // pageControlTabBar.isHidden = false
    }
    
 
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let section = indexPath.section
        let row = indexPath.row
        selectedTask = taskInSection[section][row]
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            (action: UITableViewRowAction, indexPath: IndexPath) in
            let title = "Delete '\(self.selectedTask.name)'?"
            let message = "A you sure?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action) -> Void in self.taskStore.deleteTask(self.selectedTask)
                //  self.tableTask.deleteRows(at: row, with: <#T##UITableViewRowAnimation#>)
                self.refresh()
            })
            ac.addAction(cancelAction)
            ac.addAction(deleteAction)
            self.present(ac, animated: true, completion: nil)
        }
        
        let share = UITableViewRowAction(style: .normal, title: "Details") {
            (action, indexPath) in
        }
        
        share.backgroundColor = UIColor.lightGray
        return [delete, share]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        selectedTask = taskInSection[section][row]
        if editingStyle == .delete {
            let title = "Delete \(selectedTask.name)?"
            let message = "A you sure?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            present(ac, animated: true, completion: nil)
        }
    }
}
