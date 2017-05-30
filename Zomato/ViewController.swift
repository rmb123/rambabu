//
//  ViewController.swift
//  Zomato
//
//  Created by rambabu on 29/05/17.
//  Copyright © 2017 rambabu. All rights reserved.
//

import UIKit
import SDWebImage

class HotelsTableViewCell: UITableViewCell
{
   
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var hotelDescription: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
    }
}
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{

    @IBOutlet weak var TV: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var dataArray = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        searchBar.delegate = self
        hotelsDataApiHitting()
    }
    
//MARK: --------------------------- API Hitting ----------------------------
func hotelsDataApiHitting()
{
    let headers = ["Accept":"application/json",
                   "user-key":"88e698ad87e285361080ee3a2054bbd0"]
    
    var strURL = String()
    if searchBar.text?.trimmingCharacters(in: CharacterSet.whitespaces).characters.count != 0 {
        strURL =  String(format:"https://developers.zomato.com/api/v2.1/search?entity_id=%lu&entity_type=%@&lat=%f&lon=%f&q=%@",11,"city",23.0225,72.5714,(searchBar.text?.trimmingCharacters(in: CharacterSet.whitespaces))!)
    }else
    {
        AFWrapper.svprogressHudShow(title: "Loading...", view: self)
        strURL = String(format:"https://developers.zomato.com/api/v2.1/search?entity_id=%lu&entity_type=%@&start=%lu&count=%lu&lat=%f&lon=%f",11,"city",0,30,23.0225,72.5714)
    }
    let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
    AFWrapper.requestGETURL(strURL: urlwithPercentEscapes!, params: nil, headers: headers, success:
        { (jsonDic) in
            AFWrapper.svprogressHudDismiss(view: self)
            self.dataArray = jsonDic["restaurants"] as! NSArray
            self.TV.reloadData()
        })
    { (error) in
        AFWrapper.svprogressHudDismiss(view: self)
        AFWrapper.alert("ERROR", message: error.localizedDescription, view: self)
    }
}
// MARK: ---------------------------- Search bar Delegates -------------------------------------
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
        hotelsDataApiHitting()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text?.characters.count == 0
        {
            self.searchBar.resignFirstResponder()
            hotelsDataApiHitting()
        }
        else
        {
            hotelsDataApiHitting()
        }
    }
   
// MARK: ---------------------------- TV Delegates, Datasource -------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.TV.frame.size.width * 0.33
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelsTableViewCell")! as! HotelsTableViewCell
        
        let hotelPic = URL(string: (((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey:"restaurant") as! NSDictionary)).object(forKey:"thumb") as! String)
        if hotelPic == nil
        {
            cell.hotelImage.image = UIImage.init(named: "zomato_logo.png")
        }
        else
        {
            cell.hotelImage?.sd_setImage(with: hotelPic, placeholderImage: UIImage.init(named: "zomato_logo.png"))
        }
        
        cell.hotelName.text = (((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey:"restaurant") as! NSDictionary)).object(forKey: "name") as? String
        cell.hotelDescription.text = (((((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey:"restaurant") as! NSDictionary)).object(forKey: "location") as! NSDictionary).object(forKey: "address") as! String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let str = String(format:"%@",((((dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey:"restaurant") as! NSDictionary)).object(forKey: "url") as? String)!)
        if str.characters.count == 0
        {
            AFWrapper.alert("Oops!", message: "Link not available for this Hotel.", view: self)
        }
        else
        {
            let url = NSURL(string: str)
            let wvc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            wvc.webLink = url!
            self.present(wvc, animated: true, completion: nil)
        }
    }
}

