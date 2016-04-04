//
//  MainTableViewController.swift
//  JSONBrowser
//
//  Created by steig hallquist on 4/4/16.
//  Copyright © 2016 steig hallquist. All rights reserved.
//

import UIKit

class MainTableViewController: ATNTableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    var source: AnyObject?
    var searchController:UISearchController?
    var resultsController = ATNTableViewController()
    
    let seperatorSet = NSCharacterSet(charactersInString: ".[]")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController = UISearchController(searchResultsController: self.resultsController)

        // Do any additional setup after loading the view.
        self.searchController?.searchResultsUpdater = self
        self.searchController?.searchBar.sizeToFit()
        self.searchController?.dimsBackgroundDuringPresentation = false
        self.searchController?.hidesNavigationBarDuringPresentation = false
        
        self.searchController?.delegate = self
        self.searchController?.searchBar.delegate = self
        
        self.tableView.tableHeaderView = self.searchController?.searchBar
         
        self.definesPresentationContext = true;  // know where you want UISearchController to be displayed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


    //MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let invalidStartSet = NSMutableCharacterSet.punctuationCharacterSet()
        invalidStartSet.removeCharactersInString("[")
        invalidStartSet.formUnionWithCharacterSet(NSCharacterSet.decimalDigitCharacterSet())
        
        if range.location == 0 && !text.isEmpty && invalidStartSet.characterIsMember((text as NSString).characterAtIndex(0)){
            return false
        }
        
        return true
    }
    
    //MARK: - UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        var searchString:NSString = searchController.searchBar.text!
        
        searchString = searchString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        var arange = searchString.rangeOfCharacterFromSet(seperatorSet, options: .BackwardsSearch)
        
        if arange.location != NSNotFound{
            let numericSet = NSCharacterSet.decimalDigitCharacterSet()
            
            let charAt = searchString.substringWithRange(arange)
            
            if charAt == "]" && arange.location < searchString.length{
                arange.location += 1
            } else if charAt == "." && arange.location < searchString.length - 1  && !numericSet.characterIsMember(searchString.characterAtIndex(arange.location+1)){
                arange.location = searchString.length
            }
            
            searchString = searchString.substringToIndex(arange.location)
        }
        
        var newSource:AnyObject?
        var searchResults = [(key:String, anObj:AnyObject,shown:Bool,level:Int)]()

        if searchString.length > 0 {
            if source is NSDictionary{
                newSource = getObject(searchString as String, anObject: source as! NSDictionary)
            } else if source is NSArray{
                newSource = getArray(searchString as String, anArray: source as! NSArray)
            }
        }
        
        if newSource == nil {newSource = source}

        if let tableController = self.searchController?.searchResultsController as? ATNTableViewController, theSource = getDictionary(newSource){
            for (key,value) in theSource {
                searchResults.append((key,value,false,0))
            }

            tableController.values = searchResults
            
            //tableController.tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "Cell")
            tableController.tableView.reloadData()
        }
    }
    
    //MARK: - UISearchControllerDelegate
    
    // Called after the search controller's search bar has agreed to begin editing or when
    // 'active' is set to true.
    // If you choose not to present the controller yourself or do not implement this method,
    // a default presentation is performed on your behalf.
    //
    // Implement this method if the default presentation is not adequate for your purposes.
    //
    func presentSearchController(searchController: UISearchController) {
        //
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        //
    }

    func didPresentSearchController(searchController: UISearchController) {
        //
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        //
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        //
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func getArray(lookup:String, anArray:NSArray)->AnyObject?{
        let seperatorSet = NSCharacterSet(charactersInString: ".[]")
        
        if lookup.characters[lookup.startIndex] == "[" {
            let newLook = lookup.substringFromIndex(lookup.startIndex.successor())
            
            if let theRange = newLook.rangeOfCharacterFromSet(seperatorSet){
                let firstPart = newLook.substringToIndex(theRange.startIndex)
                let separator = newLook.substringWithRange(theRange)
                let secondPart = newLook.substringFromIndex(theRange.endIndex)
                
                if separator == "]" && Int(firstPart) != nil {
                    let indx = Int(firstPart)!
                    
                    if indx < anArray.count {
                        if secondPart.isEmpty {
                            return anArray[indx]
                        } else if secondPart.characters[secondPart.startIndex] == ".", let aDict = anArray[indx] as? NSDictionary  {
                            return getObject(secondPart, anObject: aDict)
                        } else if secondPart.characters[secondPart.startIndex] == "[", let anArray = anArray[indx] as? NSArray {
                            return getArray(secondPart, anArray: anArray)
                        }
                    }
                }
            }
        }
        return nil
    }
    
    func getObject(lookup:String, anObject:NSDictionary)->AnyObject?{
        let seperatorSet = NSCharacterSet(charactersInString: ".[]")
        var newLookup = lookup
        
        if lookup.characters[lookup.startIndex] == "." {
            newLookup = lookup.substringFromIndex(lookup.startIndex.successor())
        }
        
        if let theRange = newLookup.rangeOfCharacterFromSet(seperatorSet){
            let firstPart = newLookup.substringToIndex(theRange.startIndex)
            let separator = newLookup.substringWithRange(theRange)
            let secondPart = newLookup.substringFromIndex(theRange.endIndex)
            
            if theRange.startIndex != lookup.startIndex {
                if !firstPart.isEmpty {
                    if separator == "[" , let anArray = anObject[firstPart] as? NSArray{
                        return getArray(separator+secondPart, anArray: anArray)
                    } else if separator == "." , let aDict = anObject[firstPart] as? NSDictionary {
                        return getObject(secondPart, anObject: aDict)
                    }
                }
            }
        } else if !newLookup.isEmpty {
            return anObject[newLookup]
        }
        
        return nil
    }
}
