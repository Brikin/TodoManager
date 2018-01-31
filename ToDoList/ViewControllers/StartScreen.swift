//
//  StartScreen.swift
//  ToDoList
//
//  Created by Ruslan on 28/11/2017.
//  Copyright © 2017 Ruslan. All rights reserved.
//

import UIKit

class StartScreen: UIViewController {
    
    var taskStore: TaskStore! {
        get { return (UIApplication.shared.delegate as? AppDelegate)?.taskStore }
    }
    var navigationBarController: UINavigationController!
    var tasksListTableController: TasksListTableController!
    let sectionsTitle = ["", "Smart lists", "Lists"]
    var listsInSection = [["Inbox"], ["Important", "Focused"], ["New List"] ]
    var listIdentifier = ""
    
    @IBOutlet weak var topBarHeight: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var tableLists: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var addButtonView: UIBarButtonItem!
    
    
    @IBAction func addTaskButtonTapped(_ sender: Any) {
        UIApplication.shared.statusBarView?.backgroundColor = topBar.barTintColor
        topBarHeight.constant = 44
        textField.isEnabled = true
        self.navigationController?.isNavigationBarHidden = true
        
        
        textField.becomeFirstResponder()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        if !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
        let _ = taskStore.createTask(name: textField.text!, list: "Inbox")
        textField.text = nil
        textField.isEnabled = false
        self.navigationController?.isNavigationBarHidden = false
        topBarHeight.constant = 0
    }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.viewDidLayoutSubviews()
        
        
        let roundView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        roundView.backgroundColor = UIColor.blue
        roundView.layer.cornerRadius = 10
        
      //  self.addButtonView.tintColor = UIColor.white
        
        
        
        topBarHeight.constant = 0
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //  tableLists.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        topBarHeight.constant = 0
        tableLists.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tasksListTableController = segue.destination as? TasksListTableController
        tasksListTableController.listIdentifier = listIdentifier
        
        
    }
    
}

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension StartScreen: UITableViewDelegate {
    
}

extension StartScreen: UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        let ListButtonCell = tableView.dequeueReusableCell(withIdentifier: "ListButtonCell", for: indexPath) as! ListButtonCell
        let SmartListButtonCell = tableView.dequeueReusableCell(withIdentifier: "SmartListButtonCell", for: indexPath) as! SmartListButtonCell
        
        
        if section == 2 && row == self.listsInSection[section].count {
            return ListButtonCell
        }
        
        if section == 1 && row == self.listsInSection[section].count {
            return SmartListButtonCell
        }
        
        cell.nameCell.text = self.listsInSection[section][row]
        let currentTasks = taskStore.taskForList(listName: cell.nameCell.text!)
        let currentCount = taskStore.taskForComplete(list: currentTasks, status: false)
        let countOverdue = taskStore.taskForDate(list: currentCount, dateDue: Date(), range: .overdue)
        
        if currentCount.count != 0 {
            cell.currentCount.isHidden = false
        }
        if countOverdue.count != 0 {
            cell.imageOverdue.isHidden = false
            cell.countOverdue.isHidden = false
        }
        
        cell.currentCount.text = "\(currentCount.count)"
        cell.countOverdue.text = "\(countOverdue.count)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! TableViewHeaderView
        
        if section == 0 {
            cell.drawable = false
            cell.textLabel?.backgroundColor = UIColor.white
            cell.backgroundColor = UIColor.clear
            cell.labelText.text = ""
            return cell
        }
        
        cell.textLabel?.backgroundColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        cell.labelText.text = "\(sectionsTitle[section]) "
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 10
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 30
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionsTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != 0 {
            return self.listsInSection[section].count + 1
        }
        return self.listsInSection[section].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? ListCell else { return }
        let labelContent = cell.nameCell.text

        listIdentifier = labelContent!
        
        self.performSegue(withIdentifier: "TaskList", sender: self)
        NSLog("You selected cell number: \(indexPath.row)!")
    }
}

class TableViewHeaderView: UITableViewCell {
    
    @IBOutlet weak var labelText: UILabel!
    
    var drawable = true
    
    override func draw(_ rect: CGRect) {
        if drawable {
            UIColor.lightGray.set()
            drawLine(point1: CGPoint(x: rect.minX, y: rect.height / 2.0),
                     point2: CGPoint(x: rect.maxX, y: rect.height / 2.0))
            super.draw(rect)
        }
    }
    
    private func drawLine(point1: CGPoint, point2: CGPoint) {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: point1.x, y: point1.y))
        path.addLine(to: CGPoint(x: point2.x, y: point2.y))
        path.stroke()
    }
}


