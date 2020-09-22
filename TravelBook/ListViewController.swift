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
    
    var chosenTitle = ""
    var chosenId: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        getData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace1"), object: nil)
        
    }
    
    @objc func getData() {
        
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
        
        chosenTitle = ""
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
   

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        chosenId = UUIDArray[indexPath.row]
        chosenTitle = titleArray[indexPath.row]
        performSegue(withIdentifier: "toSecondVC", sender: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSecondVC" {
            
            let secondVC = segue.destination as! ViewController
                
           
                secondVC.selectedTitle = chosenTitle
                secondVC.selectedId = chosenId
                print(secondVC.selectedTitle)
                
            
        }
    }
}
