//
//  ListViewController.swift
//  TravelBook
//
//  Created by Jamie on 2020/09/21.
//  Copyright © 2020 Jamie. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {

    var titleArray = [String]()
    var UUIDArray = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        getData()
        
    }

    func getData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                self.titleArray.removeAll(keepingCapacity: false)
                self.UUIDArray.removeAll(keepingCapacity: false)
                
                
                for result in results as! [NSManagedObject] {
                    
                    if let title = result.value(forKey: "title") as? String {
                        
                        self.titleArray.append(title)
                    }

                    
                    if let idData = result.value(forKey: "id") as? UUID {
                        
                        self.UUIDArray.append(idData)
                    }
                }
                
                tableView.reloadData()
                
            }
        } catch {
           print("error")
        }
    }
    
    
    @objc func addButtonClicked() {
        
        performSegue(withIdentifier: "toSecondVC", sender: nil)
    }
    
    
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titleArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
   

}
