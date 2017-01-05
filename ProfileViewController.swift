//
//  ViewController.swift
//  crescat
//
//  Created by Madelyn Nelson on 12/27/16.
//  Copyright © 2016 Madelyn Nelson. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var uid:String!
    var name:String!
    var position:String!
    var company:String!
    var location:String!
    var industry:String!
    var school:String!
    
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var professionalName: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        professionalName.text = name
        titleLabel.text = position + " at " + company
        locationLabel.text = location
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
