//
//  AskQuestionViewController.swift
//  crescat
//
//  Created by Madelyn Nelson on 1/5/17.
//  Copyright © 2017 Madelyn Nelson. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AskQuestionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var postQuestionButton: UIButton!
    @IBOutlet weak var charactersLabel: UILabel!
    
    var professionalNameArray: [String] = []
    var professionalUIDArray: [String] = []
    var professionalArray:[[String:AnyObject]]! // from view controller
    var followeesArray: [String] = [] // also from home view controller
    var questionArray: [[String:AnyObject]] = []

    // TODO don't hard code this to default to 0 unless the actual pickerview starts with 0 selected
    var selectedProfIndex: Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        
        questionTextView.delegate = self
        
        makePretty()
    }
    
    func makePretty() {
        questionTextView.layer.cornerRadius = 5
        
        postQuestionButton.layer.cornerRadius = 5
    }
    
    // changes characters remaining label
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        print(textView.text); //the textView parameter is the textView where text was changed

        let numChars = textView.text?.characters.count
        let remainingChars = max(150 - numChars!, 0)
        let stringChars = String(remainingChars)
        charactersLabel.text = "Characters Remaining: " + stringChars

    }
    
    // stops being able to edit if goes over 100 chars
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("chars \(textView.text.characters.count) \( text)")
        
        if(textView.text.characters.count > 150 && range.length == 0) {
            print("Please summarize in 150 characters or less")
            return false;
        }
        
        return true;
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
        selectedProfIndex = row

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return professionalNameArray[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func postQuestionButton(_ sender: Any) {
        
        // check that text view has question in it
        if (self.questionTextView.text == "")
        {
            let alert = UIAlertController(title: "Oops!", message: "Please enter a question", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let question = self.questionTextView.text
        let answer = " "
        let uid = professionalUIDArray[selectedProfIndex]
        let profName = professionalNameArray[selectedProfIndex]
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        let date = formatter.string(from: currentDate)

        var newQuestion: [String:String] = [:]
        newQuestion["question"] = question
        newQuestion["date"] = date
        newQuestion["answer"] = answer
        newQuestion["uid"] = uid
        newQuestion["profName"] = profName

        
        // add new question to question array
        print("questionArray:")
        self.questionArray = []
        self.questionArray.append(newQuestion as [String : AnyObject])
        print(self.questionArray)
        
        
        // get old questions array from firebase
        let questionsRef = FIRDatabase.database().reference(withPath: "questions")

        var numChildren:UInt!
        
        // find number of children
        questionsRef.observe(.value, with: {snapshot in
            numChildren = snapshot.childrenCount
            print("numChildren:")
            print(numChildren)
        })
            
        questionsRef.observe(.childAdded, with: { snapshot in

            //let json = child as! [String:AnyObject]

            let json = snapshot.value as! [String:AnyObject]
            
            var questionData: [String:String] = [:]
            
            let question = json["question"]
            let answer = json["answer"]
            let uid = json["uid"]
            let profName = json["profName"]
            let date = json["date"]
            
            questionData["answer"] = answer as! String?
            questionData["question"] = question as! String?
            questionData["uid"] = uid as! String?
            questionData["profName"] = profName as! String?
            questionData["date"] = date as! String?
            
            self.questionArray.append(questionData as [String : AnyObject])
            print("questionArray in snap block:")
            print(self.questionArray)
            
            if (UInt(self.questionArray.count) == numChildren + 1) {
                print("GOT ALL THE CHILDREN IN QUESTION ARRAY")
                self.updateQuestionsArrayFirebase()
            }
        })
 
    }
    
    func updateQuestionsArrayFirebase() {
        let questionsRef = FIRDatabase.database().reference(withPath: "questions")
        questionsRef.setValue(self.questionArray)
        self.postQuestionButton.titleLabel?.text = "Posted!:)"
        
        let alert = UIAlertController(title: "Success!", message: "Your question has been posted. Stay tuned for the answer.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        clearStuff()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = professionalNameArray[row]
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
    }
    
    func clearStuff() {
        self.questionTextView.text = ""
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
