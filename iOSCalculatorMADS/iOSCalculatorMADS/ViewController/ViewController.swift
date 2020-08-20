//
//  ViewController.swift
//  iOSCalculatorMADS
//
//  Created by Kumar, Akash on 8/20/20.
//  Copyright © 2020 Kumar, Akash. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    var expression = [Expression]()
    
    @IBOutlet weak var errorLabel: UILabel!{
        didSet{
            errorLabel.isHidden = true
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.isHidden = true
        }
    }
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var searchHistory: UIButton!{
        didSet{
            searchHistory.layer.cornerRadius = 6
            searchHistory.layer.masksToBounds = true
            searchHistory.layer.borderWidth = 1
            searchHistory.layer.borderColor = UIColor.white.cgColor
            searchHistory.layer.backgroundColor = UIColor.systemBlue.cgColor
            searchHistory.setTitle("Search History", for: .normal)
            searchHistory.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func searchHistoryBtnTapped(_ sender: Any) {
        getData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputTextField.delegate = self
        self.inputTextField.keyboardType = .numbersAndPunctuation
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
               inputTextField.clearButtonMode = .always
               inputTextField.clearButtonMode = .whileEditing
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        errorLabel.isHidden = true
        return true
    }


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         errorLabel.isHidden = true
        if textField == inputTextField {
              let allowedCharacters = CharacterSet(charactersIn:"*+/-0123456789 ")//Here change this characters based on your requirement
              let characterSet = CharacterSet(charactersIn: string)
              return allowedCharacters.isSuperset(of: characterSet)
          }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performAction()
        return true
    }
   
    func performAction() {
        if let textFieldString = self.inputTextField.text,textFieldString.first != "-"{
        self.inputTextField.text = solve(expression: textFieldString.replacingOccurrences(of: "+", with: " + ").replacingOccurrences(of: "*", with: " * ").replacingOccurrences(of: "-", with: " - ").replacingOccurrences(of: "/", with: " / "))
            let dict = ["expression":"\(textFieldString)","results":"\(self.inputTextField.text ?? "")"]
            DatabaseHelper.sharedInstance.saveExpressionData(object: dict)
        }
        else{
            errorLabel.isHidden = false
            errorLabel.text = "please enter the valid expression"
            errorLabel.textColor = .red
            inputTextField.becomeFirstResponder()
        }
    }
    
    func bracketEngine(expression: String) -> String {
        
        func bracketParsing(exp: String) -> [String] {
            var finalStrings = [""]
            for (_, tok) in exp.enumerated() {
                let tokAsString = "\(tok)"
                if tokAsString == "(" {
                    finalStrings.append(tokAsString)
                } else if !finalStrings[finalStrings.count-1].contains(")") && finalStrings[finalStrings.count-1].contains("(") {
                    finalStrings[finalStrings.count-1] += tokAsString
                }
            }
            finalStrings.remove(at: 0)
            return finalStrings
        }
        
        func bracketSolving(brackets: [String]) -> String {
            var finalString = expression
            for i in brackets {
                let result = solve(expression: (i.replacingOccurrences(of: "(", with: "") as AnyObject).replacingOccurrences(of: ")", with: ""))
                finalString = finalString.replacingOccurrences(of: i, with: "\(result)")
            }
            return finalString
        }
        
        return bracketSolving(brackets: bracketParsing(exp: expression))
        
    }
    
    func getData(){
        expression = DatabaseHelper.sharedInstance.getExpressionData()
        if expression.count > 0 {
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.tableView.reloadData()
            }
        }
    }
    
    
    func solve( expression: String) -> String {
        
        let expression = expression.contains("(") ? bracketEngine(expression: expression) : expression
        let operatorStack = Stack()
        let operandStack = Stack()
        let tokens = expression.components(separatedBy: " ")
        
        for (_, token) in tokens.enumerated() {
            
            if token.isNumber {
                operandStack.push(value: token)
            }
            
            if token.isOperator {
                while operatorStack.peek.precedence <= token.precedence {
                    if !operatorStack.empty {
                        var res = 0
                        switch operatorStack.peek {
                        case "+":
                            res = Int(operandStack.pop())! + Int(operandStack.pop())!
                        case "-":
                            res = Int(operandStack.selfvalue[operandStack.selfvalue.count-2])! - Int(operandStack.pop())!
                            operandStack.pop()
                        case "*":
                            res = Int(operandStack.pop())! * Int(operandStack.pop())!
                        case "/":
                            res = Int(operandStack.selfvalue[operandStack.selfvalue.count-2])! / Int(operandStack.pop())!
                            operandStack.pop()
                        default:
                            res = 0
                        }
                        operatorStack.pop()
                        operandStack.push(value: "\(res)")
                    }
                }
                operatorStack.push(value: token)
            }
            
        }
        
        while !operatorStack.empty {
            var res = 0
            switch operatorStack.peek {
            case "+":
                res = Int(operandStack.pop())! + Int(operandStack.pop())!
            case "-":
                res = Int(operandStack.selfvalue[operandStack.selfvalue.count-2])! - Int(operandStack.pop())!
                operandStack.pop()
            case "*":
                res = Int(operandStack.pop())! * Int(operandStack.pop())!
            case "/":
                res = Int(operandStack.selfvalue[operandStack.selfvalue.count-2])! / Int(operandStack.pop())!
                operandStack.pop()
            default:
                res = 0
            }
            operatorStack.pop()
            operandStack.push(value: "\(res)")
        }
        
        
        return String(operandStack.pop())
        
    }
}

extension String {
    
    var precedence: Int {
        get {
            switch self {
                case "*":
                return 0
                case "+":
                return 1
                case "/":
                return 2
                case "-":
                return 3
            default:
                return 100
            }
        }
    }
    
    var isOperator: Bool {
        get {
            return ("+-*/" as NSString).contains(self)
        }
    }
    
    var isNumber: Bool {
        get {
            return !isOperator && self != "(" && self != ")" && self != "" && self != " "
        }
    }
    
}

extension ViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expression.count > 0 && expression.count <= 10{
            return expression.count
        }
        else if expression.count > 10{
             return 10
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let equation = expression[indexPath.row].expression,let resultsOfEqn = expression[indexPath.row].results {
        cell.textLabel?.text = "\(equation)  \(resultsOfEqn)"
        }
        return cell
    }
    
    
}

