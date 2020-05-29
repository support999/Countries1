//
//  ViewController.swift
//  Countries
//
//  Created by Amit Saxena on 29/05/20.
//  Copyright © 2020 Amit Saxena. All rights reserved.
//

import UIKit
import MBProgressHUD
import SVGKit

class ViewController: UIViewController {
    
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var country_table: UITableView!
    
    var search = String()
    var arr_country = [model_country_list]()
    var arr_country_filter = [model_country_list](){
        didSet{
            self.country_table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_search.delegate = self
        self.get_country_list()
    }
}

//********************************************************************************************************
// MARK: - Filter
//********************************************************************************************************
extension ViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if string.isEmpty{
            search = "\(search.dropLast())"
        }
        else {
            search = textField.text! + string
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.arr_country_filter = self.arr_country.filter{(($0.country.lowercased()).contains(search.lowercased()))}
        MBProgressHUD.hide(for: self.view, animated: true)
        return true
    }
}


//********************************************************************************************************
// MARK: - Api Services
//********************************************************************************************************
extension ViewController{
    func get_country_list(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let url = "https://restcountries.eu/rest/v2/"
        APIServiceManager.shared.api_Calling_Get_Request(url: url) { (result, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            for item in (result as? [[String:Any]] ?? [[:]]){
                
                let name = item["name"] as? String ?? ""
                let flag = item["flag"] as? String ?? ""
                
                self.arr_country.append(model_country_list(country: name, flag: flag))
            }
        }
    }
}


//********************************************************************************************************
// MARK: - TableView And Datasource
//********************************************************************************************************
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_country_filter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:country_list_cell = country_table.dequeueReusableCell(withIdentifier: "country_list_cell", for: indexPath as IndexPath) as! country_list_cell
        
        cell.lbl_name.text = self.arr_country_filter[indexPath.row].country
        
        let flag = self.arr_country_filter[indexPath.row].flag
        if flag.count > 0{
            DispatchQueue.global(qos: .userInitiated).async {
                let svg = URL(string: flag)!
                let data = try? Data(contentsOf: svg)
                let receivedimage: SVGKImage = SVGKImage(data: data)
                DispatchQueue.main.async {
                    cell.img_flag.image = receivedimage.uiImage
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let n_vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryDetailsViewController") as! CountryDetailsViewController
        n_vc.country_name = self.arr_country_filter[indexPath.row].country
        self.navigationController?.pushViewController(n_vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}























