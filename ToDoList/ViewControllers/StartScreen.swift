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
    
    var tasksListTableController: TasksListTableController!
    let sectionsTitle = ["", "Smart lists", "Lists"]
    var listsInSection = [["Inbox"], ["Important", "Focused"], ["New List"] ]
    var listIdentifier = ""
    
    
    
    @IBOutlet weak var tableLists: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    
    
    
    @IBAction func addTaskButtonTapped(_ sender: Any) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tasksListTableController = segue.destination as? TasksListTableController
        tasksListTableController.listIdentifier = listIdentifier
        
        
    }
    
}

extension StartScreen: UITableViewDelegate {
    
}

extension StartScreen: UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        cell.nameCell.text = self.listsInSection[section][row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionsTitle[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 0 {
            
        } else {
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 10, y: 6))
            path.addLine(to: CGPoint(x: 365, y: 6))
            
            // Create a `CAShapeLayer` that uses that `UIBezierPath`:
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.black.cgColor
            shapeLayer.lineWidth = 0.2

            (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
            (view as! UITableViewHeaderFooterView).textLabel?.textAlignment = NSTextAlignment.center
            (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont(name: "Arial", size: 12.0)
            (view as! UITableViewHeaderFooterView).textLabel?.backgroundColor = UIColor.white
            (view as! UITableViewHeaderFooterView).layer.addSublayer(shapeLayer)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        }
        return 10
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionsTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
