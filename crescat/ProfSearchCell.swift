//
//  ProfSearchCell.swift
//  crescat
//
//  Created by Madelyn Nelson on 12/30/16.
//  Copyright © 2016 Madelyn Nelson. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfSearchCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var followToggle: UISwitch!
    
    let uid:String! = nil
    
    @IBAction func toggleSwitched(_ sender: Any) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        let userPath = "users/" + userID!
        let followeesPath = "users/" + userID! + "listOfFollowees"
        let usersRef = FIRDatabase.database().reference(withPath: userPath)
        let followeesRef = FIRDatabase.database().reference(withPath: followeesPath)
        
        if followToggle.isOn {
            // follow this professional
            print("toggle is on!")
            
            // get old array
            let oldFollowees = [String]()

            usersRef.observe(.childAdded, with: { snapshot in
                if (snapshot.hasChild("listOfFollowees")) {
                    print("is following people already")
                }
                else {
                    print("is following NO ONE")
                }
            })
        }
        else {
            // unfollow this professional
        }
    }
}
