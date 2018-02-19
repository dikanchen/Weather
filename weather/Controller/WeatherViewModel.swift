//
//  WeatherViewModel.swift
//  weather
//
//  Created by User on 2/19/18.
//  Copyright © 2018 dikan.chen. All rights reserved.
//

import UIKit

class WeatherViewModel{
    private var myweather: weather
    init(myurl:String){
        self.myweather = weather(urlstring: myurl)
    }
    
    var urlstring1 :String{
        return myweather.url
    }
}
