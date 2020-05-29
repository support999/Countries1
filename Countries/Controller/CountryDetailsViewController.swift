//
//  CountryDetailsViewController.swift
//  Countries
//
//  Created by Amit Saxena on 29/05/20.
//  Copyright © 2020 Amit Saxena. All rights reserved.
//

import UIKit
import MBProgressHUD
import SVGKit

class CountryDetailsViewController: UIViewController {
    
    @IBOutlet var img_flag: UIImageView!
    
    @IBOutlet var lbl_country_name: UILabel!
    @IBOutlet var lbl_capital: UILabel!
    @IBOutlet var lbl_region: UILabel!
    @IBOutlet var lbl_population: UILabel!
    @IBOutlet var lbl_area: UILabel!
    @IBOutlet var lbl_timezones: UILabel!
    
    var country_name = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("country_name:- ", country_name)
        self.get_country_details()
    }
    
    func setupUI(){
        self.img_flag.layer.cornerRadius = 10
        self.img_flag.layer.borderColor = UIColor.lightGray.cgColor
        self.img_flag.layer.borderWidth = 1.0
    }
}


//********************************************************************************************************
// MARK: - Api Services
//********************************************************************************************************
extension CountryDetailsViewController{
    func get_country_details(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
       
        let url = "https://restcountries.eu/rest/v2/name/\(country_name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
        print("url:- ", url)
        
        APIServiceManager.shared.api_Calling_Get_Request(url: url) { (result, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            print("result:- ", result as Any)
            
            for item in (result as? [[String:Any]] ?? [[:]]){
                
                if (item["name"] as? String ?? "") == self.country_name{
                    
                    let flag = item["flag"] as? String ?? ""
                    let capital = item["capital"] as? String ?? ""
                    let region = item["region"] as? String ?? ""
                    let population = item["population"] as? Int ?? 0
                    let area = item["area"] as? Int ?? 0
                    let timezones = item["timezones"] as? [String] ?? []
                    
                    if flag.count > 0{
                        let svg = URL(string: flag)!
                        let data = try? Data(contentsOf: svg)
                        let receivedimage: SVGKImage = SVGKImage(data: data)
                        self.img_flag.image = receivedimage.uiImage
                    }
                    
                    self.lbl_country_name.text = self.country_name
                    self.lbl_capital.text = capital
                    self.lbl_region.text = region
                    self.lbl_population.text = "\(population)"
                    self.lbl_area.text = "\(area)"
                    self.lbl_timezones.text = "\(timezones[0])"
                }
            }
        }
    }
}
