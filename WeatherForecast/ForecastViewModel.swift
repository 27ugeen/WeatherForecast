//
//  WeatherForecastDataModel.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 28/9/2022.
//

import Foundation
import Alamofire
import CoreLocation

enum WeatherURLs: String {
//    case current = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid="
    case daily = "https://api.openweathermap.org/data/3.0/onecall?units=metric&appid="
}


class ForecastViewModel {
    
    private var apiKey: Data {
        get {
            guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
                fatalError("Couldn't find file 'Info.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? Data else {
                fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
            }
            return value
        }
    }
    //MARK: - methods
    
    private func encodeApiKey(_ key: Data) -> String {
        let key = String(data: key, encoding: .utf8)
        return key ?? ""
    }

    
//    var currentWeather: ForecastModel?
//       var currentWeatherCoordinate: String = ""
//
       func createURLForCurrentWeather(_ coordinate: CLLocationCoordinate2D) -> String {
           let headRL = WeatherURLs.daily.rawValue
           let cApiKey = self.encodeApiKey(apiKey)
           let coordinateParams = "&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)"

           let resultURL = headRL + cApiKey + coordinateParams

           return resultURL
       }
//
//       func decodeModelFromData(completition: @escaping (ForecastModel) -> Void) {
//           if let url = URL(string: currentWeatherCoordinate) {
//               let decoder = JSONDecoder()
//               decoder.dateDecodingStrategy = .iso8601
//
//               let request = AF.request(url)
//
//               request.validate().responseDecodable(of: ForecastModel.self, decoder: decoder) { data in
//                   if let uValue = data.value {
//                       completition(uValue)
//
//                       print("All: \(String(describing: uValue))")
//                       print("Weather descript: \(String(describing: uValue.weather[0].descript))")
//                   }
//               }
//           }
//       }
    
    lazy var locationManager = CLLocationManager()
    func getData() {
//            let cUrl = self.createUrl(VideoURLs.playlist.rawValue, "&playlistId=", "UUu5jfQcpRLm9xhmlSd5S8xw")
        let cUrl = createURLForCurrentWeather(locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
            print(cUrl)
            
    //        let u = "https://youtube.googleapis.com/youtube/v3/videos?part=snippet&part=statistics&part=player&id=x31vGxoI7go&key=AIzaSyBahXEiv91xvS7j9fZijlRMMHT59QMwRRM"
    //        print(u)
            
            
            let req = AF.request(cUrl)

            req.responseJSON { data in
                print(data)

            }
        }
}
