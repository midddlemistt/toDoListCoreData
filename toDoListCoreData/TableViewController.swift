//
//  TableViewController.swift
//  toDoListCoreData
//
//  Created by 123 on 7.02.24.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var tasks: [Tasks] = []
    
    @IBAction func plusTasks(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Task", message: "Enter Task", preferredStyle: .alert)
        
        let saveTask = UIAlertAction(title: "Save", style: .default) { action in
            let textField = alertController.textFields?.first
            if let newTask = textField?.text {
                self.saveTask(withTitle: newTask)
                self.tableView.reloadData()
            }
        }
        
        alertController.addTextField { _ in }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        
        alertController.addAction(saveTask)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func deletetasks(_ sender: UIBarButtonItem) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        if let tasks = try? context.fetch(fetchRequest) {
            for task in tasks {
                context.delete(task)
            }
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.tasks.removeAll(keepingCapacity: false)
        tableView.reloadData()
    }
    
    
    
    
    func saveTask(withTitle title:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else { return }
        
        let taskObject = Tasks(entity: entity, insertInto: context)
        taskObject.title = title
        
        do {
            try context.save()
            tasks.append(taskObject)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Сell")
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Сell", for: indexPath)

        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        

        return cell
    }

    
    
}
