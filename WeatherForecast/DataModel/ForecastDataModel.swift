//
//  ForecastDataModel.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 29/9/2022.
//

import Foundation
import Alamofire
import CoreLocation

enum WeatherURLs: String {
    case daily = "https://api.openweathermap.org/data/3.0/onecall?units=metric&appid="
    case geo = "http://api.openweathermap.org/geo/1.0/direct?limit=10&appid="
    case city = "http://api.openweathermap.org/geo/1.0/reverse?limit=1&appid="
}

struct ForecastModel: Decodable {
    var city: String = ""
    var country: String = ""
    
    let daily: [DailyModel]
    let hourly: [HourlyModel]
    var lat: Double
    var lon: Double
    let timezoneOffset: Int
    
    enum CodingKeys: String, CodingKey {
        case daily
        case hourly
        case lat
        case lon
        case timezoneOffset = "timezone_offset"
        
        case current
    }
    //1======current==========
    let currentTime: Int
    let sunrise: Int
    let sunset: Int
    let humidity: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [WeatherModel]
    
    enum CurrentCodingKeys: String, CodingKey {
        case currentTime = "dt"
        case sunrise
        case sunset
        case humidity
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        daily = try container.decode([DailyModel].self, forKey: .daily)
        hourly = try container.decode([HourlyModel].self, forKey: .hourly)
        lat = try container.decode(Double.self, forKey: .lat)
        lon = try container.decode(Double.self, forKey: .lon)
        timezoneOffset = try container.decode(Int.self, forKey: .timezoneOffset)
        //1=====================current===========================
        let cContainer = try container.nestedContainer(keyedBy: CurrentCodingKeys.self, forKey: .current)
        currentTime = try cContainer.decode(Int.self, forKey: .currentTime)
        sunrise = try cContainer.decode(Int.self, forKey: .sunrise)
        sunset = try cContainer.decode(Int.self, forKey: .sunset)
        humidity = try cContainer.decode(Int.self, forKey: .humidity)
        windSpeed = try cContainer.decode(Double.self, forKey: .windSpeed)
        windDeg = try cContainer.decode(Int.self, forKey: .windDeg)
        weather = try cContainer.decode([WeatherModel].self, forKey: .weather)
    }
}

struct WeatherModel: Decodable {
    let descript: String
    
    enum CodingKeys: String, CodingKey {
        case descript = "main"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        descript = try container.decode(String.self, forKey: .descript)
    }
}

struct DailyModel: Decodable {
    let dTime: Int
    let dWeather: [WeatherModel]
    
    enum CodingKeys: String, CodingKey {
        case dTime = "dt"
        case dWeather = "weather"
        
        case dTemp = "temp"
    }
    
    let dTempDay: Double
    let dTempNight: Double
    
    enum TemperatureCodingKeys: String, CodingKey {
        case dTempDay = "day"
        case dTempNight = "night"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dTime = try container.decode(Int.self, forKey: .dTime)
        dWeather = try container.decode([WeatherModel].self, forKey: .dWeather)
        
        let tempContainer = try container.nestedContainer(keyedBy: TemperatureCodingKeys.self, forKey: .dTemp)
        dTempDay = try tempContainer.decode(Double.self, forKey: .dTempDay)
        dTempNight = try tempContainer.decode(Double.self, forKey: .dTempNight)
    }
}

struct HourlyModel: Decodable {
    let hTime: Int
    let hTemp: Double
    let hWeather: [WeatherModel]
    
    enum CodingKeys: String, CodingKey {
        case hTime = "dt"
        case hTemp = "temp"
        case hWeather = "weather"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hTime = try container.decode(Int.self, forKey: .hTime)
        hTemp = try container.decode(Double.self, forKey: .hTemp)
        hWeather = try container.decode([WeatherModel].self, forKey: .hWeather)
    }
}

struct CityModel: Decodable {
    let country: String
    let name: String
    let lat: Double
    let lon: Double
}

struct NameCityModel: Decodable {
    let country: String
    let name: String
}


class ForecastDataModel {
    //MARK: - props
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
    
    private func createURLForCity(_ coord: CLLocationCoordinate2D) -> String {
        let headRL = WeatherURLs.city.rawValue
        let cApiKey = self.encodeApiKey(apiKey)
        let qStr = "&lat=\(coord.latitude)&lon=\(coord.longitude)"
        let resultURL = headRL + cApiKey + qStr
        return resultURL
    }
    
    private func createURLForGeo(_ name: String) -> String {
        let headRL = WeatherURLs.geo.rawValue
        let cApiKey = self.encodeApiKey(apiKey)
        let qStr = "&q=\(name)"
        let resultURL = headRL + cApiKey + qStr
        return resultURL
    }
    
    private func createURLForCurrentWeather(_ coordinate: CLLocationCoordinate2D) -> String {
        let headRL = WeatherURLs.daily.rawValue
        let cApiKey = self.encodeApiKey(apiKey)
        let coordinateParams = "&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)"
        
        let resultURL = headRL + cApiKey + coordinateParams
        
        return resultURL
    }
    
    func takeCityFromLoc(_ coord: CLLocationCoordinate2D, completition: @escaping (NameCityModel) -> Void) {
        let cUrl = self.createURLForCity(coord)
        
        if let url = URL(string: cUrl) {
            let decoder = JSONDecoder()
            let request = AF.request(url)
            
            request.validate().responseDecodable(of: [NameCityModel].self, decoder: decoder) { data in
                if let uValue = data.value {
                    completition(uValue.first ?? NameCityModel(country: "UA", name: "Kyiv"))
                }
            }
        }
    }
    
    func takeForecast(_ coordinate: CLLocationCoordinate2D, completition: @escaping (ForecastModel) -> Void) {
        let cUrl = createURLForCurrentWeather(coordinate)
        
        if let url = URL(string: cUrl) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let request = AF.request(url)
            
            request.validate().responseDecodable(of: ForecastModel.self, decoder: decoder) { data in
                if let uValue = data.value {
                    completition(uValue)
                }
            }
        }
    }
    
    func decodeModelFromData(_ coordinate: CLLocationCoordinate2D, completition: @escaping (ForecastModel, NameCityModel) -> Void) {
        self.takeCityFromLoc(coordinate) { cityNameModel in
            self.takeForecast(coordinate) { forecastModel in
//                print("from dm \(cityNameModel)")
                completition(forecastModel, cityNameModel)
            }
        }
    }
    
    //===========================================
    
    
    func takeLocFromName(_ name: String, completition: @escaping ([CityModel]) -> Void) {
        let cUrl = self.createURLForGeo(name)
        
        if let url = URL(string: cUrl) {
            let decoder = JSONDecoder()
            
            let request = AF.request(url)
            
            request.validate().responseDecodable(of: [CityModel].self, decoder: decoder) { data in
                if let uValue = data.value {
                    if uValue.isEmpty {
                        print("No such city found")
                        return
                    }
                    completition(uValue)
                }
            }
        }
    }
//    lazy var locationManager = CLLocationManager()
//    func getData() {
//        //            let cUrl = self.createUrl(VideoURLs.playlist.rawValue, "&playlistId=", "UUu5jfQcpRLm9xhmlSd5S8xw")
//        let cUrl = createURLForCurrentWeather(locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
//        print(cUrl)
//
//        let req = AF.request(cUrl)
//
//        req.responseJSON { data in
//            print(data)
//
//        }
//    }
    
}



