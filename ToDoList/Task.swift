//
//  Task.swift
//  ToDoList
//
//  Created by Ruslan on 28/11/2017.
//  Copyright © 2017 Ruslan. All rights reserved.
//

import UIKit


class Task: NSObject {
    var name: String
    var date: Date
    var complete: Bool
    var list: String
    var smartList: String
    var section: String
    
    init(name: String, date: Date, complete: Bool, list: String, smartList: String, section: String) {
        self.name = name
        self.date = date
        self.complete = complete
        self.list = list
        self.smartList = smartList
        self.section = section
        
    }
    
//    func encode decode
    
    //    func encode(with aCoder: NSCoder) {
    //        aCoder.encode(name, forKey: "name")
    //        aCoder.encode(date, forKey: "date")
    //        aCoder.encode(finished, forKey: "finished")
    //        aCoder.encode(finished, forKey: "category")
    //        aCoder.encode(section, forKey: "section")
    //
    //
    //    }
    //
    //    required init(coder aDecoder: NSCoder) {
    //        name = aDecoder.decodeObject(forKey: "name") as! String
    //        date = aDecoder.decodeObject(forKey: "date") as! String
    //        finished = aDecoder.decodeBool(forKey: "finished")
    //        category = aDecoder.decodeObject(forKey: "category") as? String ?? "inbox"
    //        section = aDecoder.decodeObject(forKey: "section") as? String ?? "OVERDUE"
    //        super.init()
    //    }
    
}

class TaskStore {
    
    var allTasks = [Task]()
    
    // Save Load data
    
    //    init() {
    //        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [Item] {
    //            allItems = archivedItems
    //
    //        }
    //    }
    
    //    let itemArchiveURL: URL = {
    //        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    //        let documentDerictory = documentsDirectories.first!
    //        return documentDerictory.appendingPathComponent("items.archive")
    //    }()
    //
    //    func saveChanges() -> Bool {
    //        print("saving items to: \(itemArchiveURL.path)")
    //        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
    //    }
    
    func createTask(name: String, list: String) -> Task {
        let newTask = Task(name: name,
                           date: Date(),
                           complete: false,
                           list: list,
                           smartList: "",
                           section: "TODAY")
        allTasks.append(newTask)
        return newTask
    }
    
    func deleteTask(_ task: Task) {
        if let index = allTasks.index(of: task) {
            allTasks.remove(at: index)
        }
    }
    
    func taskForList(listName: String) -> [Task] {
        
        return allTasks.filter({$0.list == listName})
    }
    
    func taskForComplete(status: Bool) -> [Task] {
        return allTasks.filter({ $0.complete == status })
    }
    
    func taskForDate(list: [Task], dateDue: Date, range: String) -> [Task]  {
        var result: [Task]!
        
        
        if range == "today" {
            result = list.filter({$0.date.roundedByDay == Date().roundedByDay })
        } else if range == "tomorrow" {
            result = list.filter({$0.date.roundedByDay == changeDate(date: dateDue, value: "tomorrow").roundedByDay})
        } else if range == "week" {
            result = list.filter({$0.date.roundedByDay > Date().roundedByDay && $0.date.roundedByDay != changeDate(date: dateDue, value: "tomorrow").roundedByDay})
        } else if range == "overdue" {
            result = list.filter({$0.date.roundedByDay < Date().roundedByDay})
        }
        
        return result
    }
    
    func changeDate(date: Date, value: String) -> Date {
        let calendar = Calendar.current
        var newDate: Date!
        if value == "tomorrow" {
            let date = calendar.date(byAdding: .day, value: 1, to: Date())
            newDate = date!
        } else if value == "week" {
            let date = calendar.date(byAdding: .day, value: 7, to: date)
            newDate = date!
        }
        return newDate
    }
    
}

extension Date {
    var roundedByDay: Date {
        let calendar = Calendar.current
        let components = DateComponents(year: calendar.component(.year, from: self),
                                        month: calendar.component(.month, from: self),
                                        day: calendar.component(.day, from: self))
        
        let date = calendar.date(from: components)
        return date!
    }
}
