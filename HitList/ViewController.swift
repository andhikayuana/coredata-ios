//
//  ViewController.swift
//  HitList
//
//  Created by Andhika Yuana on 27/01/20.
//  Copyright © 2020 Andhika Yuana. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //let ROW_IDENTIFIER = "Cell"

    @IBOutlet weak var tableView: UITableView!
//    var names: [String] = []
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        title = "The List"
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "Cell"
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(
            title: "New Name",
            message: "Add a new name",
            preferredStyle: .alert
        )
        
        let saveAction = UIAlertAction(
            title: "Save",
            style: .default
        ) {
            
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .default
        )
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(
            forEntityName: "Person",
            in: managedContext
        )!
        let person = NSManagedObject(
            entity: entity,
            insertInto: managedContext
        )
        person.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}

//MARK: - UITableViewDataSource
   extension ViewController: UITableViewDataSource {
       
       func tableView(
            _ tableView: UITableView,
            numberOfRowsInSection section: Int
       ) -> Int {
        return people.count
       }
       
       func tableView(
            _ tableView: UITableView,
            cellForRowAt indexPath: IndexPath
       ) -> UITableViewCell {
           
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath
        )
        cell.textLabel?.text = person.value(forKey: "name") as? String
        
        return cell
       }
   }
