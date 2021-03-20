//
//  appBrain.swift
//  covid
//
//  Created by Richard Basdeo on 11/10/20.
//

import Foundation

//protocol that a class must follow to use app brain
protocol AppBrainDelegate {
    func updateUI(_ appBrain: AppBrain, resultModel: CovidModel)
    func didFailWithError (error: Error)
    
}

//model for the app
struct AppBrain {
    
    //let a class set themelves as the delegate so they can update the UI
    var delegate: AppBrainDelegate?
    
    //base url
    let url = "https://api.covidtracking.com/v1/states/"
    
    
    //states i want to look up data for
    let pickerArray = ["NY", "CA", "FL", "CT","DC", "NJ", "PA", "TX", "VA"]
    
    
    
    //perfor api call
    func performRequest (userChoice: String){
        
        //create api url by using user state choice
        let userState = String("\(url)\(userChoice)/current.json")
        
        //create the url
        if let url = URL(string: userState){
            
           
            //Create the browser
            let session = URLSession(configuration: .default)
            
            
            //give browser a task
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                
                //if error tell delegate class to perform their error method
                if let e = error {
                    self.delegate?.didFailWithError(error: e)
                    return
                }
            
                //if no error unwrap data retrieved from api call
                if let safeData = data {
        
                    //parse the data and call the delegate method to update the ui
                    if let theReturn = parseJson(theData: safeData){
                        self.delegate?.updateUI(self, resultModel: theReturn)
                    }
  
                }
            }
            //start the brower task
            task.resume()
        }
    }
    
    
    
    
    func parseJson (theData: Data) -> CovidModel?{
        
        //create a decoder
        let decoder = JSONDecoder()
        
        //must be wrapped in a do catach block
        do{
            //try to decode data with covid data created
            let decodedData = try decoder.decode(CovidData.self, from: theData)
            
            //create a covide model and return it
            let theReturn = CovidModel(totalDeaths: decodedData.death
                                       , peopleInHospital: decodedData.hospitalizedCurrently,
                                       hospitalIncrease: decodedData.hospitalizedIncrease, morePeopleTestPositive: decodedData.positiveIncrease)
            
            return theReturn
        }
        
        //if there was an error return nil
        catch{
            
            print ("Error 2")
            return nil
        }
    }
}

