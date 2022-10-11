//
//  Welcome2ViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 08/09/21.
//

import UIKit

class Welcome2AnswerTemp {
    var _id: String?
    var answerId: String?
    var questionId: String?
    var answer: String?
}

class Welcome2ViewController: UIViewController {

    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var btnA: UIBUtton_Designable!
    @IBOutlet var btnB: UIBUtton_Designable!
    @IBOutlet var btnC: UIBUtton_Designable!
    
    var welcome2ViewModel = Welcome2ViewModel()
    var welcome2QuestionData: Welcome2QuestionResponse?
    var tempAnswerModel: Welcome2AnswerTemp?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcome2ViewModel.delegate = self

        getQuestionData()
    }
    
    func setupQuestionData(data: Welcome2QuestionResponse?) {
        
        guard let questionData = data else { return }
        welcome2QuestionData = questionData
        
        tempAnswerModel = Welcome2AnswerTemp()
        
        lblQuestion.text = questionData.result?[0].question
        
//        btnA.setTitle("A. \(welcome2QuestionData?.result?[0].anss?[0].answer ?? "A")", for: .normal)
//        btnB.setTitle("B. \(welcome2QuestionData?.result?[0].anss?[1].answer ?? "B")", for: .normal)
//        btnC.setTitle("C. \(welcome2QuestionData?.result?[0].anss?[2].answer ?? "C")", for: .normal)
        
        btnA.setTitle(welcome2QuestionData?.result?[0].anss?[0].answer, for: .normal)
        btnB.setTitle(welcome2QuestionData?.result?[0].anss?[1].answer, for: .normal)
        btnC.setTitle(welcome2QuestionData?.result?[0].anss?[2].answer, for: .normal)
        
        btnA.setImage(UIImage.init(named: "smile-grey"), for: .normal)
        btnB.setImage(UIImage.init(named: "healthier-grey"), for: .normal)
        btnC.setImage(UIImage.init(named: "more-successful-grey"), for: .normal)
        
        btnA.borderColor = UIColor.gray
        btnB.borderColor = UIColor.gray
        btnC.borderColor = UIColor.gray
    }

    @IBAction func btnA(_ sender: Any) {
        tempAnswerModel?.answerId = (welcome2QuestionData?.result?[0].anss?[0].answerId)!
        tempAnswerModel?.questionId = (welcome2QuestionData?.result?[0].anss?[0].questionId)!
        tempAnswerModel?.answer = (welcome2QuestionData?.result?[0].anss?[0].answer)!
        
        btnA.setImage(UIImage.init(named: "smile-orange"), for: .normal)
        btnB.setImage(UIImage.init(named: "healthier-grey"), for: .normal)
        btnC.setImage(UIImage.init(named: "more-successful-grey"), for: .normal)
        
        btnA.borderColor = UIColor.customeBorderOrangeColor()
        btnB.borderColor = UIColor.gray
        btnC.borderColor = UIColor.gray
    }
    
    @IBAction func btnB(_ sender: Any) {
        tempAnswerModel?.answerId = (welcome2QuestionData?.result?[0].anss?[1].answerId)!
        tempAnswerModel?.questionId = (welcome2QuestionData?.result?[0].anss?[1].questionId)!
        tempAnswerModel?.answer = (welcome2QuestionData?.result?[0].anss?[1].answer)!
        
        btnA.setImage(UIImage.init(named: "smile-grey"), for: .normal)
        btnB.setImage(UIImage.init(named: "healthier-orange"), for: .normal)
        btnC.setImage(UIImage.init(named: "more-successful-grey"), for: .normal)
        
        btnA.borderColor = UIColor.gray
        btnB.borderColor = UIColor.customeBorderOrangeColor()
        btnC.borderColor = UIColor.gray
    }
    
    @IBAction func btnC(_ sender: Any) {
        tempAnswerModel?.answerId = (welcome2QuestionData?.result?[0].anss?[2].answerId)!
        tempAnswerModel?.questionId = (welcome2QuestionData?.result?[0].anss?[2].questionId)!
        tempAnswerModel?.answer = (welcome2QuestionData?.result?[0].anss?[2].answer)!
        
        btnA.setImage(UIImage.init(named: "smile-grey"), for: .normal)
        btnB.setImage(UIImage.init(named: "healthier-grey"), for: .normal)
        btnC.setImage(UIImage.init(named: "more-successful-orange"), for: .normal)
        
        btnA.borderColor = UIColor.gray
        btnB.borderColor = UIColor.gray
        btnC.borderColor = UIColor.customeBorderOrangeColor()
    }
    
    @IBAction func btnNext(_ sender: Any) {
        dump(tempAnswerModel)
        saveAnswer()
    }
}
