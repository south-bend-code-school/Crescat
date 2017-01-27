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
    
    @IBOutlet weak var uid: UILabel!
    
    // handles following and unfollowing of professionals
    @IBAction func toggleSwitched(_ sender: Any) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        let userPath = "users/" + userID!
        let usersRef = FIRDatabase.database().reference(withPath: userPath)
        
        // uid of selected professional
        let uidText = uid.text! as String

        
        
        if followToggle.isOn {
            // follow this professional
            //print("toggle is on!")

            // get old array
            usersRef.observe(.childAdded, with: { snapshot in
                print(snapshot.value)
                
                if (snapshot.hasChild("listOfFollowees")) {
                    // is following profs already
                    print("is following SOME PROFS ALREADY!")
                    
                    let json = snapshot.value as! [String:AnyObject]
                    var oldFollowees = json["listOfFollowees"] as! [String]
                    
                    // check if is not already following this prof
                    if (!oldFollowees.contains(uidText)) {
                        oldFollowees.append(uidText)
                        usersRef.child("userInfo/listOfFollowees").setValue(oldFollowees)
                    }
                    
                }
                else {
                    // is following no one
                    print("is following NO ONE!")
                    
                    var followeesArr = [String]()
                    followeesArr.append(uidText)
                    
                    // added this
                    usersRef.child("userInfo/listOfFollowees").setValue(followeesArr)

                    //self.updateQuestionsArrayFirebase() // IDK why this is here?
                }
                
                
            })
        }
        else {
            // unfollow this professional
            //print("toggle is off")
            
            // get old array
            usersRef.observe(.childAdded, with: { snapshot in
                print(snapshot.value)
                
                if (snapshot.hasChild("listOfFollowees")) {
                    // is following some prof(s) already
                    
                    let json = snapshot.value as! [String:AnyObject]
                    var oldFollowees = json["listOfFollowees"] as! [String]
                    
                    // check that already following this prof
                    if (oldFollowees.contains(uidText)) {
                        oldFollowees.remove(at: oldFollowees.index(of: uidText)!)
                        usersRef.child("userInfo/listOfFollowees").setValue(oldFollowees)
                    }
                    
                }
                else {
                    print("ERROR! Tried to unfollow a prof, but is following NO ONE to begin with")
                }
                
                
            })
        }
    }
}
