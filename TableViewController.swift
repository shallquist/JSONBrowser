//
//  TableViewController.swift
//  JSONBrowser2
//
//  Created by steig hallquist on 3/28/16.
//  Copyright © 2016 steig hallquist. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var source: AnyObject?
    var values = [(key:String, anObj:AnyObject,shown:Bool,level:Int)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.cellLayoutMarginsFollowReadableWidth = false
        
        //source = ["greet":"hello","values":["one",["a":"two","b":"four"],"three"]]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let newSource = getDictionary(source){
            for (key,value) in newSource {
                values.append((key,value,false,0))
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        values.removeAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? TableViewCell{
            var text = ""
            let aValue = values[indexPath.row]
            
            let title = aValue.shown ? "-" : "+"
            
            cell.button.setTitle(title, forState: .Normal)
            cell.buttonLeading.constant = CGFloat(values[indexPath.row].level) * 5.0

            cell.fxShowHideRow = nil
            cell.button.hidden = true
                
            switch aValue.anObj {
            case is NSArray, is NSDictionary:
                cell.fxShowHideRow = self.showHideRow
                cell.button.hidden = false
                
                text = "{\(getNumRows(aValue.anObj))}"
            case is NSString:
                text = aValue.anObj as! String
            case is NSNumber:
                text = (aValue.anObj as! NSNumber).stringValue
            case is NSNull:
                text = "Null"
            default:
                text = ""
            }
            
            cell.label.text = "\(aValue.key) : \(text)"
                        
            return cell
        }

        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 28
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
  
    func showHideRow(show:Bool, cell:UITableViewCell){
        let indexPath = self.tableView.indexPathForCell(cell)

        if indexPath != nil {
            if !values[indexPath!.row].shown {
                expandRow(indexPath!.row)
            } else {
                collapseRow(indexPath!.row)
            }
        }
    }
    
    func expandRow(row:Int) {
        values[row].shown = true
        let level = values[row].level + 1
        
        let newValues = getDictionary(values[row].anObj) ?? [values[row].key:values[row].anObj]
        
        var indx = 0
        
        for (key,value) in newValues{
            values.insert((key,value,false,level), atIndex: row + 1 + indx)
            indx += 1
        }

        self.tableView.reloadData()
    }
    
    func collapseRow(row:Int){
        values[row].shown = false
        
        for _ in 0..<getNumRows(values[row].anObj) {
            let cVal = values[row + 1]
            if cVal.shown {collapseRow(row + 1)}
            
            values.removeAtIndex(row + 1)
        }
        
        self.tableView.reloadData()
    }
    
    func getNumRows(anObj:AnyObject)->Int{
        switch anObj {
        case is NSDictionary:
            return (anObj as! NSDictionary).count
        case is NSArray:
            return (anObj as! NSArray).count
        default:
            return 0
        }
    }
    
    func getDictionary(source:AnyObject?) -> [String:AnyObject]?{
        var newSource: [String:AnyObject]?
        
        if source is [String:AnyObject] {
            newSource = source as? [String:AnyObject]
        } else if source is [AnyObject] {
            newSource = [String:AnyObject]()
            
            for (indx, anObj) in (source as? NSArray)!.enumerate(){
                newSource!["\(indx)"] = anObj
            }
        } else {
            newSource = nil
        }
        
        return newSource
    }
}
