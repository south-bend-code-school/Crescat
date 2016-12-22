//
//  SignUpVCViewController.swift
//  crescat
//
//  Created by Madelyn Nelson on 12/22/16.
//  Copyright © 2016 Madelyn Nelson. All rights reserved.
//

import UIKit

class SignUpVCViewController: UIViewController {

    @IBOutlet weak var studentProfessional: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var companyMajorTextField: UITextField!
    @IBOutlet weak var positionYearTextField: UITextField!
    @IBOutlet weak var industryTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        

        
    }

    @IBAction func studentProfessionalAction(_ sender: Any) {
        print("hey")
        if studentProfessional.selectedSegmentIndex == 0 {
            print("value is student");
            companyMajorTextField.placeholder = "Major"
            positionYearTextField.placeholder = "Year"
        }
        if studentProfessional.selectedSegmentIndex == 1 {
            print("value is professional");
            companyMajorTextField.placeholder = "Company"
            positionYearTextField.placeholder = "Position"
        }
        


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
