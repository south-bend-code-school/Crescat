//
//  HomeVC.swift
//  crescat
//
//  Created by Madelyn Nelson on 12/22/16.
//  Copyright © 2016 Madelyn Nelson. All rights reserved.
//

import UIKit
import FirebaseAuth


class HomeVC: UIViewController {

    @IBOutlet weak var userEmailLabel: UILabel!
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let user = FIRAuth.auth()?.currentUser
        self.userEmailLabel.text = user?.email


    }
    
    @IBAction func logout(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        self.performSegue(withIdentifier: "homeLogoutSegue", sender: self)
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
