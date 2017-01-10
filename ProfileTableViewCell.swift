//
//  ProfileTableViewCell.swift
//  crescat
//
//  Created by Madelyn Nelson on 1/6/17.
//  Copyright © 2017 Madelyn Nelson. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var questionArray: [[String:AnyObject]] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func savePressed(_ sender: Any) {
        print("saved")
        updateQuestionOnFirebase()
    }
    
    func updateQuestionOnFirebase() {
        // get old questions array from firebase
        let questionsRef = FIRDatabase.database().reference(withPath: "questions")
        
        var numChildren:UInt!
        
        // find number of children
        questionsRef.observe(.value, with: {snapshot in
            numChildren = snapshot.childrenCount
        })
        
        
        questionsRef.observe(.childAdded, with: { snapshot in
            let json = snapshot.value as! [String:AnyObject]
            
            var questionData: [String:String] = [:]
            
            let question = json["question"]
            let answer = json["answer"]
            let uid = json["uid"]
            let profName = json["profName"]
            let date = json["date"]
            
            let questionPlusQ = "Q: " + (question as! String)
            
            if ((date as! String == self.dateLabel.text) && (questionPlusQ as! String == self.questionLabel.text)) {
                //print("FOUND THE QUESTION YOU WANA EDIT")
                
                var newAns = self.answerTextView.text as! String?
                newAns = newAns?.replacingOccurrences(of: "A: ", with: "")
                questionData["answer"] = newAns
            }
            else {
                questionData["answer"] = answer as! String?
                print(date as! String)
                print(self.dateLabel.text)
                print(questionPlusQ as! String)
                print(self.questionLabel.text)
            }

            questionData["question"] = question as! String?
            questionData["uid"] = uid as! String?
            questionData["profName"] = profName as! String?
            questionData["date"] = date as! String?
            
            self.questionArray.append(questionData as [String : AnyObject])
            print("questionArray in snap block:")
            //print(self.questionArray)
            
            if (UInt(self.questionArray.count) == numChildren) {
                //print("GOT ALL THE CHILDREN IN QUESTION ARRAY")
                self.updateQuestionsArrayFirebase()
            }
            
        })

    }
    
    func updateQuestionsArrayFirebase() {
        let questionsRef = FIRDatabase.database().reference(withPath: "questions")
        questionsRef.setValue(self.questionArray)

    }


}
