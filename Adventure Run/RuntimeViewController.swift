//
//  RuntimeViewController.swift
//  Adventure Run
//
//  Created by Maria Sam on 6/10/16.
//  Copyright © 2016 Maria Sam. All rights reserved.
//

import UIKit

struct Variables {
    static var runtimes = [Runtime(runtime: "", date: ""), Runtime(runtime: "RUNTIMES:", date: "")]
}

class RuntimeViewController: UITableViewController {
    
    
    var testing = [Int]()
    var const = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        //print(Variables.runtimes)
        print(testing)
        print(const)
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
       /* self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths([
            // - 2 or 1?
            NSIndexPath(forRow: Variables.runtimes.count-1, inSection: 0)
            ], withRowAnimation: .Automatic)
        self.tableView.endUpdates()*/
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Variables.runtimes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        
        var runtime : Runtime
        
        runtime = Variables.runtimes[indexPath.row]
        
        cell.textLabel?.text = runtime.runtime
        
        return cell
    }
}



















