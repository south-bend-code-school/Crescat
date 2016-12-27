//
//  SimpleTableViewCell.swift
//  crescat
//
//  Created by Madelyn Nelson on 12/26/16.
//  Copyright © 2016 Madelyn Nelson. All rights reserved.
//

import UIKit

class SimpleTableViewCell: UITableViewCell {

    @IBOutlet var cellTitle: UILabel!
    @IBOutlet var cellQuestion: UILabel!
    @IBOutlet var cellAnswer: UILabel!
    @IBOutlet var cellDate: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "simpleCell")
        
        print("initializing simple table cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //self.cellTitle.text = "title from class"
        //self.cellTitle.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        //self.cellTitle.backgroundColor = UIColor.blue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   

}
