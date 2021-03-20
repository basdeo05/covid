//
//  ViewController.swift
//  covid
//
//  Created by Richard Basdeo on 11/10/20.
//

import UIKit

class ViewController: UIViewController {
    
    
    //labels
    @IBOutlet weak var totalDeathLabel: UILabel!
    
    @IBOutlet weak var currentInHospitalLabel: UILabel!
    
    @IBOutlet weak var hospitalIncreaseLabel: UILabel!
    
    @IBOutlet weak var positiveTestIncreaseLabel: UILabel!
    
   
    
    //outlet to picker
    @IBOutlet weak var uiPicker: UIPickerView!
    
    
    
    //conect to the model
    var appManager = AppBrain()
    
    
    
    //set this class as the delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        appManager.delegate = self
        uiPicker.delegate = self
        uiPicker.dataSource = self
    }
    
}


extension ViewController: UIPickerViewDataSource{
    
    //how many columns we want for picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //how many rows we want for the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return appManager.pickerArray.count
    }
    
    
}

extension ViewController: UIPickerViewDelegate {
    
    //where to get row title
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return appManager.pickerArray[row]
        
    }
    
    //what to do when a row is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let state = appManager.pickerArray[row]
        appManager.performRequest(userChoice: state)
        
    }
    
}


//protocol methods
extension ViewController: AppBrainDelegate {
    
    //update the UI
    func updateUI(_ appBrain: AppBrain, resultModel: CovidModel) {
        
        DispatchQueue.main.async {
            self.totalDeathLabel.text =
                String("Total Deaths: \(resultModel.totalDeaths)")
            self.currentInHospitalLabel.text =
                String("People Currently In Hospital: \(resultModel.peopleInHospital)")
            self.hospitalIncreaseLabel.text =
                String("Patient Increase In Hospital: \(resultModel.hospitalIncrease)")
            self.positiveTestIncreaseLabel.text =
                String("Positive Test Increased From Yesterday: \(resultModel.morePeopleTestPositive)")
        }
    }
    
    
    //if there was error inform programmer
    func didFailWithError(error: Error) {
        print ("error 1, \(error)")
        
    }
}

