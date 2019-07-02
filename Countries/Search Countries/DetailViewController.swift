//
//  Constants.swift
//  Countries
//
//  Created by Pooja Bohora on 28/06/19.
//  Used to show details of selected country

import UIKit
import SDWebImageSVGCoder

class DetailViewController: UIViewController {
    
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var imgviwCountry: UIImageView!
    @IBOutlet weak var lblRegion: UILabel!
    @IBOutlet weak var lblCapital: UILabel!
    @IBOutlet weak var lblPopulation: UILabel!
    @IBOutlet weak var lblSubRegion: UILabel!
    @IBOutlet var btnSave: UIBarButtonItem!
    
    var detailCountry: Country? {
        didSet {
            configureView()
        }
    }
    
    //MARK :- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- User defined methods
    
    /// Sets values to controls for selected country
    func configureView() {
        if let detailCountry = detailCountry {
            if let _ = lblCountryName, let _ = imgviwCountry {
                
                lblCountryName.text = detailCountry.name
                
                if let flagLink = detailCountry.flag
                {
                    if let flagUrl = URL(string:flagLink){
                        Utils.shared.setImage(url: flagUrl, imageView: imgviwCountry)
                    }
                }
                
                lblSubRegion.text = "Subregion: " + (detailCountry.subregion ?? "")
                lblRegion.text = "Region: " + (detailCountry.region ?? "")
                lblCapital.text = "Capital: " + (detailCountry.capital ?? "")
                
                if let population = detailCountry.population{
                    self.lblPopulation.text = "Population: " + String(describing: population)
                }
                
                if CountryListPresenter().checkIfSaved(country: detailCountry)
                {
                    self.navigationItem.rightBarButtonItem?.isEnabled=false
                }
                else{
                    self.navigationItem.rightBarButtonItem?.isEnabled=true
                }
            }
        }
    }
    
    
    /// Saves country locally
    @IBAction func saveCountry()
    {
        if let country = detailCountry{
            CountryListPresenter().saveCountry(country: country)
            self.navigationItem.rightBarButtonItem?.isEnabled=false
        }
    }
    
    
}

