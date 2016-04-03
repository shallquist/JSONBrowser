//
//  TableViewCell.swift
//  JSONBrowser2
//
//  Created by steig hallquist on 3/28/16.
//  Copyright © 2016 steig hallquist. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var buttonLeading: NSLayoutConstraint!
    
    var fxShowHideRow:((Bool, UITableViewCell)->Void)?
    var tapGesture:UITapGestureRecognizer?
    var rowSelected = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //tapGesture = UITapGestureRecognizer(target: self, action: #selector(TableViewCell.showHideRow))
        self.topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TableViewCell.showHideRow)))
        
        self.button.setTitle("+", forState: .Normal)
        self.button.setTitle("-", forState: .Selected)
    }
    
    override func prepareForReuse() {
        self.fxShowHideRow = nil
        self.label.text = ""
        self.button.selected = false
        self.button.hidden = true
        self.button.setTitle("+", forState: .Normal)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showHideRow(){
        self.button.selected = !self.button.selected
        self.fxShowHideRow?(self.button.selected,self)
    }

    @IBAction func buttonAction(sender: UIButton) {
        self.showHideRow()
    }
}
