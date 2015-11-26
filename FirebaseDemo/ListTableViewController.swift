//
//  ListTableViewController.swift
//  FirebaseDemo
//
//  Created by Ravi Shankar on 22/11/15.
//  Copyright © 2015 Ravi Shankar. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    let firebase = Firebase(url:"https://<your_identifier>.firebaseio.com/profiles")
    var items = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        items = [NSDictionary]()
        
        loadDataFromFirebase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath)
        
        configureCell(cell, indexPath: indexPath)
        tableViewStyle(cell)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let dict = items[indexPath.row]
            let name = dict["name"] as! String
            
            // delete data from firebase
            
            let profile = firebase.ref.childByAppendingPath(name)
            profile.removeValue()
        }
    }
    
    // MARK:- Configure Cell
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let dict = items[indexPath.row]
        
        cell.textLabel?.text = dict["name"] as? String
        
        let dobTimeInterval = dict["dob"] as! NSTimeInterval
        populateTimeInterval(cell, timeInterval: dobTimeInterval)
        
        let base64String = dict["photoBase64"] as! String
        populateImage(cell, imageString: base64String)
      
    }
    
    // MARK:- Populate Timeinterval
    
    func populateTimeInterval(cell: UITableViewCell, timeInterval: NSTimeInterval) {
        
        let date = NSDate(timeIntervalSinceNow: timeInterval)
        let dateStr = formatDate(date)
        
        cell.detailTextLabel?.text = dateStr
    }
    
    // MARK:- Populate Image
    
    func populateImage(cell:UITableViewCell, imageString: String) {
        
        let decodedData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
 
        let decodedImage = UIImage(data: decodedData!)
        
        cell.imageView!.image = decodedImage

    }
    
    // MARK:- Apply TableViewCell Style
    
    func tableViewStyle(cell: UITableViewCell) {
        cell.contentView.backgroundColor = backgroundColor
        cell.backgroundColor = backgroundColor
        
        cell.textLabel?.font =  UIFont(name: "HelveticaNeue-Medium", size: 15)
        cell.textLabel?.textColor = textColor
        cell.textLabel?.backgroundColor = backgroundColor
        
        cell.detailTextLabel?.font = UIFont.boldSystemFontOfSize(15)
        cell.detailTextLabel?.textColor = UIColor.grayColor()
        cell.detailTextLabel?.backgroundColor = backgroundColor
    }
    
    // MARK:- Load data from Firebase
    
    func loadDataFromFirebase() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        firebase.observeEventType(.Value, withBlock: { snapshot in
            var tempItems = [NSDictionary]()
            
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                let dict = child.value as! NSDictionary
                tempItems.append(dict)
            }
            
            self.items = tempItems
            self.tableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
        })
    }
}