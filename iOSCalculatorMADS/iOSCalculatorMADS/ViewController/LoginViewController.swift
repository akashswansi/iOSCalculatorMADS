//
//  LoginViewController.swift
//  iOSCalculatorMADS
//
//  Created by Kumar, Akash on 8/20/20.
//  Copyright © 2020 Kumar, Akash. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    var userDetails = [UserDetails]()
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var noteLabel: UILabel!{
        didSet{
            noteLabel.text = "Please Use AkashKumar as Username and AkashKumar as password"
            noteLabel.textColor = .white
        }
    }
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.layer.cornerRadius = 6
            loginButton.layer.masksToBounds = true
            loginButton.layer.borderWidth = 1
            loginButton.layer.borderColor = UIColor.systemBlue.cgColor
            loginButton.setTitle("Login", for: .normal)
        }
    }
    
    @IBAction func LoginBtnTapped(_ sender: Any) {
        self.errorLabel.isHidden = true
        if isValidLogin(){
        let vc = self.storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: false)
        }
        else if passwordTextField.text == "" && userNameTextField.text != ""{
            self.errorLabel.isHidden = false
            self.userNameTextField.becomeFirstResponder()
            self.passwordTextField.text = ""
            self.errorLabel.text = "Password can't be empty"
            self.errorLabel.textColor = .red
        }
        else if userNameTextField.text == "" && passwordTextField.text != "" {
            self.errorLabel.isHidden = false
            self.userNameTextField.becomeFirstResponder()
            self.passwordTextField.text = ""
            self.errorLabel.text = "Username can't be empty"
            self.errorLabel.textColor = .red
        }
        else if userNameTextField.text == "" && passwordTextField.text == "" {
            self.errorLabel.isHidden = false
            self.userNameTextField.becomeFirstResponder()
            self.passwordTextField.text = ""
            self.errorLabel.text = "Username and Password can't be empty"
            self.errorLabel.textColor = .red
        }
        else{
             self.errorLabel.isHidden = false
            self.userNameTextField.becomeFirstResponder()
            self.passwordTextField.text = ""
            self.errorLabel.text = "Incorrect username and password"
            self.errorLabel.textColor = .red
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.errorLabel.isHidden = true
        userDetails = DatabaseHelper.sharedInstance.getUserDetailsData()

        // Do any additional setup after loading the view.
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.errorLabel.isHidden = true
        return true
    }
    func isValidLogin()->Bool{
        if userNameTextField.text == userDetails[0].userID && passwordTextField.text == userDetails[0].password{
            return true
        }
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
