//
//  AskQuestionViewController.swift
//  crescat
//
//  Created by Madelyn Nelson on 1/5/17.
//  Copyright © 2017 Madelyn Nelson. All rights reserved.
//

import UIKit

class AskQuestionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var postQuestionButton: UIButton!
    
    var professionalNameArray: [String] = []
    var professionalUIDArray: [String] = []
    var professionalArray:[[String:AnyObject]]! // from view controller
    var followeesArray: [String] = [] // also from home view controller

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return professionalNameArray.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return professionalNameArray[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func postQuestionButton(_ sender: Any) {
        self.postQuestionButton.titleLabel?.text = "Posted!:)"
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
