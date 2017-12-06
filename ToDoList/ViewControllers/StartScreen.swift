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
    
    
    
    @IBOutlet weak var tableLists: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var topBar: UIToolbar!
    

    @IBAction func addTaskButtonTapped(_ sender: Any) {
        UIApplication.shared.statusBarView?.backgroundColor = topBar.barTintColor
        textField.isEnabled = true
        self.navigationController?.isNavigationBarHidden = true
        textField.becomeFirstResponder()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let _ = taskStore.createTask(name: textField.text!, list: "Inbox")
        textField.text = nil
        textField.isEnabled = false
        self.navigationController?.isNavigationBarHidden = false

    }
    
    override func viewDidLoad() {
     super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      //  tableLists.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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

//        cell.countOverdue.isHidden = true
//        cell.currentCount.isHidden = true
//        cell.imageOverdue.isHidden = true

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

        cell.textLabel?.backgroundColor = UIColor.white
       cell.backgroundColor = UIColor.clear
        cell.labelText.text = "\(sectionsTitle[section]) "

        return cell
    }
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionsTitle[section]
    }*/
    /*
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 0 {
            (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
            return
        } else {
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 10, y: 6))
            path.addLine(to: CGPoint(x: 365, y: 6))
            
            // Create a `CAShapeLayer` that uses that `UIBezierPath`:
            
            let sublayersCount = (view as! UITableViewHeaderFooterView).layer.sublayers?.count ?? 0
            guard sublayersCount <= 2 else { return }
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.black.cgColor
            shapeLayer.lineWidth = 0.2

            (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.lightGray
            (view as! UITableViewHeaderFooterView).textLabel?.textAlignment = NSTextAlignment.center
            (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont(name: "Arial", size: 12.0)
            (view as! UITableViewHeaderFooterView).textLabel?.backgroundColor = UIColor.white
            (view as! UITableViewHeaderFooterView).layer.addSublayer(shapeLayer)
        }
    }*/
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 15
        }
        return 15
    }
    
    
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
        let cell = tableView.cellForRow(at: indexPath) as! ListCell
        let labelContent = cell.nameCell.text
        listIdentifier = labelContent!

        self.performSegue(withIdentifier: "TaskList", sender: self)
        
        
        
        NSLog("You selected cell number: \(indexPath.row)!")
    }
}

class TableViewHeaderView: UITableViewCell
{
    @IBOutlet weak var labelText: UILabel!
    
    override func draw(_ rect: CGRect) {
        UIColor.lightGray.set()
       drawLine(point1: CGPoint(x: rect.minX, y: rect.height / 2.0),
                 point2: CGPoint(x: rect.maxX, y: rect.height / 2.0))
        super.draw(rect)
    }

    private func drawLine(point1: CGPoint, point2: CGPoint) {
        let path = UIBezierPath()

        path.move(to: CGPoint(x: point1.x, y: point1.y))
        path.addLine(to: CGPoint(x: point2.x, y: point2.y))
        path.stroke()
    }
}
