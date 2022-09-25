//
//  ViewController.swift
//  SportKozar - Application for coaches
//
//  Created by Raman Kozar on 27/08/2022.
//

import UIKit
import Foundation

//  Common class Sportsman
//  Properties:
//      firstName: String
//      lastName: String
//      club: String
//
class Sportsman {
    
    var firstName: String
    var lastName: String
    var club: String
    
    //  Write a class initializer
    init(firstName: String, lastName: String, club: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.club = club
    }
    
    //  Method for obtaining the name of a coach with a club
    func getFullNameWithClub(firstName: String, lastName: String, club: String) -> String {
        return "Coach: \(firstName) \(lastName), club: \(club)"
    }
}

//  Common class Coaches. Inherited from the Sportsman class
//  Properties:
//      total: Double
//      win: Double
//
class Coaches: Sportsman {
    
    var total: Double
    var win: Double
    
    //  Write a class initializer. There are new properties. First we initialize them, and then from the superclass.
    init(total: Double, win: Double, firstName: String, lastName: String, club: String) {
        self.total = total
        self.win = win
        super.init(firstName: firstName, lastName: lastName, club: club)
    }
    
    //  Coach Rating Calculation Method
    func calculateScore(win: Double, total: Double) -> String {
        
        var finalScoreStr: String = ""
        var finalScore: Double = 0
        
        finalScore = round(win / total * 100)
        finalScoreStr = "score: \(finalScore)%"
        
        return finalScoreStr
    }
    
}

//  Common class ViewController
//  !!! Confirmation of the UITextFieldDelegate delegation protocol
//
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //  Data array for table
    private var stringArray: [[String]] = [[]]
    
    //  Number of sections
    private var counterSection = 0
    
    //  Form elements (input fields)
    @IBOutlet weak var coachFirstName: UITextField!
    @IBOutlet weak var coachLastName: UITextField!
    @IBOutlet weak var coachClub: UITextField!
    @IBOutlet weak var coachTotal: UITextField!
    @IBOutlet weak var coachWin: UITextField!
    
    //  Create an outlet for the text field
    @IBOutlet weak var coachFirstNameOutlet: UITextField!
    @IBOutlet weak var coachLastNameOutlet: UITextField!
    @IBOutlet weak var coachClubOutlet: UITextField!
    @IBOutlet weak var coachTotalOutlet: UITextField!
    @IBOutlet weak var coachWinOutlet: UITextField!
    
    //  Form elements (table)
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        //  Setting Standard Table Properties
        tableView.delegate = self
        tableView.dataSource = self
        
        //  Making our View Controller a UITextFieldDelegate protocol delegate
        coachFirstName.delegate = self
        coachLastName.delegate = self
        coachClub.delegate = self
        coachWin.delegate = self
        coachTotal.delegate = self
        
    }
    
    //  Method for getting the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return stringArray.count
    }
    
    //  Standard Method for TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stringArray[section].count
    }
    
    //  Standard Method for TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        //  Get a cell
        guard let cell = (tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.id,
                                                        for: indexPath) as? MyTableViewCell)
            else {
                fatalError()
        }
        
        //  Writing to the label of a cell of text from a table
        cell.myLabel.text = stringArray[indexPath.section][indexPath.row]
        return cell
        
    }
    
    //  Override the textFieldShoudReturn method, explicitly refer to the text field and use the resignFirstResponser method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        coachFirstName.resignFirstResponder()
        coachLastName.resignFirstResponder()
        coachClub.resignFirstResponder()
        coachWin.resignFirstResponder()
        coachTotal.resignFirstResponder()
        
        return true
        
    }
    
    //  Button click event
    @IBAction func addTrainerAction(_ sender: Any) {
    
        //  I don't know how to make it so that only a number can be entered in the input field on the form (controller).
        //  Therefore, I wrote a check so that if nothing is entered or not a number is entered, nothing happens.
        //  Otherwise there will be an error.
        if checkValues(coachFirstName.text!,
                       coachLastName.text!,
                       coachClub.text!,
                       coachWin.text!,
                       coachTotal.text!) {
         
            //  Getting the entered values from the form (controller)
            let coachTotalDouble: Double = Double(coachTotal.text!)!
            let coachWinDouble: Double = Double(coachWin.text!)!
           
            let coachFirstNameString = coachFirstName.text!
            let coachLastNameString = coachLastName.text!
            let coachClubString = coachClub.text!
            
            
            //  Get the full name and club of the coach
            let fullNameWithClub = Sportsman(firstName: coachFirstNameString,
                                             lastName: coachLastNameString,
                                             club: coachClubString).getFullNameWithClub(firstName: coachFirstNameString,
                                                                                      lastName: coachLastNameString,
                                                                                      club: coachClubString)
           
            //  Getting a coach rating
            let trainercalculateScore = Coaches(total: coachTotalDouble,
                                                win: coachWinDouble,
                                                firstName: coachFirstNameString,
                                                lastName: coachLastNameString,
                                                club: coachClubString).calculateScore(win: coachWinDouble, total: coachTotalDouble)
            
            
            stringArray[counterSection].append(fullNameWithClub + ", " + trainercalculateScore)

            //  Add a row to the table and subsequently display it on the form (controller)
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath.init(row: stringArray.count - 1, section: counterSection)], with: .automatic)
            tableView.endUpdates()
            
            tableView.reloadData()
            
            clearData(coachWin: coachWin,
                      coachTotal: coachTotal,
                      coachClub: coachClub,
                      coachFirstName: coachFirstName,
                      coachLastName: coachLastName)
            
            //  Hiding the keyboard after pressing a button
            view.endEditing(true)
            
        }
        
    }
    
    //  Value Filling and Validation Method
    private func checkValues(_ firstName: String, _ lastName: String, _ club: String, _ win: String, _ total: String) -> Bool {
        
        if !firstName.isEmpty
            && !lastName.isEmpty
            && !club.isEmpty && (!win.isEmpty && isDouble(text: win)) && (!total.isEmpty && isDouble(text: total)) {
            
            return true
            
        } else {
            return false
        }
        
    }
    
    //  Input validation method: whether it is a number or not
    private func isDouble(text: String) -> Bool {
        
        guard let _ = Double(text.replacingOccurrences(of: " ", with: " "))
            else {
                return false
        }
        
        return true
    }
    
    //  Method to clear form data (controller)
    private func clearData(coachWin: UITextField,
                      coachTotal: UITextField,
                      coachClub: UITextField,
                      coachFirstName: UITextField,
                      coachLastName: UITextField) {
        
        coachWin.text = ""
        coachTotal.text = ""
        coachClub.text = ""
        coachFirstName.text = ""
        coachLastName.text = ""
        
    }
    
}

