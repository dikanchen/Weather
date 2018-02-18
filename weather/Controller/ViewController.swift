//
//  ViewController.swift
//  weather
//
//  Created by User on 2/16/18.
//  Copyright © 2018 dikan.chen. All rights reserved.
//

import UIKit
struct howsweather{
    let main:String
    let description:String
    let icon:String
    
    init (main:String, description:String, icon:String){
        self.main = main
        self.description = description
        self.icon = icon
    }
}

class ViewController: UIViewController{
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var zipcodeTextfield: UITextField!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var temp_min: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var temp_max: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var weatherimg: UIImageView!
    
    @IBAction func setcCityTapped(_ sender: AnyObject) {
        getweather(urlstring: "http://api.openweathermap.org/data/2.5/weather?zip=\(zipcodeTextfield.text!),us&APPID=c4a4d7e0b3a596c0610cfea3849d19ea")
    }
    
    @IBAction func reset(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "zipcode")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let defaultzipcode = UserDefaults.standard.value(forKey: "zipcode")!
        getweather(urlstring: "http://api.openweathermap.org/data/2.5/weather?zip=\(defaultzipcode),us&APPID=c4a4d7e0b3a596c0610cfea3849d19ea")
        
    }
    
    func getweather(urlstring:String){
        guard let url = URL(string: urlstring) else{return}
        URLSession.shared.dataTask(with: url){(data,response,error) in
            guard let data = data else{return}
            do{if error == nil{
                guard let json = try
                    JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary else {return}
                if let name = json["name"] as? String{
                    print(name)
                    DispatchQueue.main.async {
                        self.city.text = name
                    }
                }
                if let main = json["main"] as? NSDictionary{
                    if let temp = main["temp"] as? Double{
                        let fahrenheit = (temp-273)*5/9 + 32
                        if fahrenheit > 90{
                            DispatchQueue.main.async {
                                self.background.backgroundColor = UIColor.red
                            }
                        }
                        else{
                            DispatchQueue.main.async{
                                self.background.backgroundColor = UIColor.blue
                            }
                        }
                        DispatchQueue.main.async {
                            self.tempLabel.text = String(format: "%.2f", fahrenheit)
                        }
                    }
                    if let pressure = main["pressure"] as? Int{
                        print(pressure)
                        DispatchQueue.main.async {
                            self.pressure.text = "Pressure: \(pressure)"
                        }
                    }
                    if let humidity = main["humidity"] as? Int{
                        print(humidity)
                        DispatchQueue.main.async {
                            self.humidity.text = "Humidity: \(humidity)"
                        }
                    }
                    if let temp_min = main["temp_min"] as? Double{
                        print (temp_min)
                        let minf = (temp_min-273)*5/9 + 32
                        DispatchQueue.main.async {
                            self.temp_min.text = "Temp min: \(String(format: "%.2f", minf))"
                        }
                    }
                    if let temp_max = main["temp_max"] as? Double{
                        print(temp_max)
                        let maxf = (temp_max-273)*5/9 + 32
                        DispatchQueue.main.async {
                            self.temp_max.text = "Temp max: \(String(format: "%.2f", maxf))"
                        }
                    }
                }
                guard let dictionary = json as? [String:Any] else{return}
                guard let result = dictionary["weather"] as? [[String:Any]] else {return}
                let weather:[howsweather] = result.flatMap{
                    guard let main = $0["main"] as? String else {return nil}
                    guard let description = $0["description"] as? String else{return nil}
                    guard let icon = $0["icon"] as? String else{return nil}
                    DispatchQueue.main.async {
                        self.descriptionLabel.text = main
                    }
                    print(main)
                    print(description)
                    print(icon)
                    let url_img = URL(string:"http://openweathermap.org/img/w/\(icon).png")
                    let session = URLSession(configuration: .default)
                    let getImageFromUrl = session.dataTask(with: url_img!){ (data, response, error) in
                        if let e = error{
                            print("Error:\(e)")
                        }
                        else{
                            if (response as? HTTPURLResponse) != nil{
                                if let imageData = data{
                                    let image = UIImage(data: imageData)
                                    DispatchQueue.main.async {
                                        self.weatherimg.image = image
                                    }
                                }else{
                                    print("no image found")
                                }
                            }else{
                                print("no response from server")
                            }
                        }
                    }
                    getImageFromUrl.resume()
                    return howsweather(main:main, description:description, icon:icon)
                    
                }
                
                }
                
            }catch let jsonErr{
                print("Error",jsonErr)
            }
            }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

