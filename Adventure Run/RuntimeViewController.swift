//
//  RuntimeViewController.swift
//  Adventure Run
//
//  Created by Maria Sam on 6/10/16.
//  Copyright © 2016 Maria Sam. All rights reserved.
//

import UIKit
import CoreData
/*
struct Variables {
    static var runtimes = [Runtime(runtime: "", date: ""), Runtime(runtime: "RUNTIMES:", date: "")]
}*/

class RuntimeViewController: UITableViewController {
    
    
    var testing = [Int]()
    var const = 0
    var runhistories = [NSManagedObject]()
    var count = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        //print(Variables.runtimes)
        print(testing)
        print(const)
        count = runhistories.count
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
       
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "RunHistory")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            runhistories = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if(runhistories.count != count) {
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([
                // - 2 or 1?
                NSIndexPath(forRow: runhistories.count-1, inSection: 0)
                ], withRowAnimation: .Automatic)
            self.tableView.endUpdates()
            count = runhistories.count
        }
        
        print("count \(runhistories.count)")
        
        

        //self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runhistories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        
        var runhistory : NSManagedObject
        
        runhistory =  runhistories[indexPath.row]
        
        cell.textLabel?.text = runhistory.valueForKey("runtime") as? String
        
        return cell
    }
}



















