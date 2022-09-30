//
//  WeatherForecastDataModel.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 28/9/2022.
//

import Foundation
import CoreLocation

struct ForecastStub {
    var city: String = ""
    var country: String = ""
    let lat: Double
    let lon: Double
    let timezoneOffset: Int
    let current: [CurrentStub]
    var daily: [DailyStub]
    let hourly: [HourlyStub]
}

struct CurrentStub {
    let currentTime: Int
    let sunrise: Int
    let sunset: Int
    let humidity: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [WeatherStub]
}

struct WeatherStub {
    let descript: String
}

struct DailyStub {
    let dTime: Int
    let dWeather: [WeatherStub]
    let dTempDay: Double
    let dTempNight: Double
}

struct HourlyStub {
    let hTime: Int
    let hTemp: Double
    let hWeather: [WeatherStub]
}

struct CoordinateCityStub {
    let country: String
    let name: String
    let lat: Double
    let lon: Double
}

struct NameCityStub {
    let country: String
    let name: String
}

struct Range {
    let from: Int
    let to: Int
}

class ForecastViewModel {
    //MARK: - props
    private let dataModel: ForecastDataModel
    
    private let weatherIcon: [String:String] = [
        "day.Clear" : "ic_white_day_bright",
        "day.Clouds" : "ic_white_day_cloudy",
        "day.Rain" : "ic_white_day_shower",
        "day.Drizzle" : "ic_white_day_rain",
        "day.Thunderstorm" : "ic_white_day_thunder",
        "night.Clear" : "ic_white_night_bright",
        "night.Clouds" : "ic_white_night_cloudy",
        "night.Rain" : "ic_white_night_shower",
        "night.Drizzle" : "ic_white_night_rain",
        "night.Thunderstorm" : "ic_white_night_thunder"
    ]
    
    private let windDirection: [String:Range] = [
        "icon_wind_s": Range(from: 360, to: 0),
        "icon_wind_sw": Range(from: 1, to: 89),
        "icon_wind_w": Range(from: 90, to: 90),
        "icon_wind_nw": Range(from: 91, to: 179),
        "icon_wind_n": Range(from: 180, to: 180),
        "icon_wind_ne": Range(from: 181, to: 269),
        "icon_wind_e": Range(from: 270, to: 270),
        "icon_wind_se": Range(from: 271, to: 359)
    ]
    
    //MARK: - init
    init(dataModel: ForecastDataModel) {
        self.dataModel = dataModel
    }
    //MARK: - methods
    func setWeatherIcon(_ isDay: Bool, _ icon: String) -> String {
        let name = String(format: "%@.%@", isDay ? "day" : "night", icon)
        return weatherIcon[name] ?? ""
    }
    
    func setWindDirection(_ direct: Int) -> String {
        var res = ""
        for (key, rangeVals) in windDirection {
            if rangeVals.from > 360 || rangeVals.from < 0 || rangeVals.to > 360 || rangeVals.to < 0 {
                continue
            }
            if direct >= rangeVals.from && direct <= rangeVals.to {
                res = key
                break
            }
        }
        return res
    }
    
    private func createCurrentForecastStub(_ fModel: ForecastModel?, _ cModel: NameCityModel?, completition: @escaping (ForecastStub) -> Void) {
        
        let newCWeather = WeatherStub(descript: fModel?.weather[0].descript ?? "no CW")
        
        let cur = fModel
        
        let newCurrent = CurrentStub(currentTime: Int(cur?.currentTime ?? 0),
                                     sunrise: Int(cur?.sunrise ?? 0),
                                     sunset: Int(cur?.sunset ?? 0),
                                     humidity: Int(cur?.humidity ?? 0),
                                     windSpeed: cur?.windSpeed ?? 0,
                                     windDeg: Int(cur?.windDeg ?? 0),
                                     weather: [newCWeather])
        let dailyArr = fModel?.daily
        
        var newDailyArr: [DailyStub] = []
        if let uDailyArr = dailyArr {
            
            for (_, dayItem) in uDailyArr.enumerated() {
                let day = dayItem
                let newDWeather = WeatherStub(descript: day.dWeather[0].descript)
                
                let newD = DailyStub(dTime: Int(day.dTime),
                                     dWeather: [newDWeather],
                                     dTempDay: day.dTempDay,
                                     dTempNight: day.dTempNight)
                newDailyArr.append(newD)
            }
        }
        
        let hourlyArr = fModel?.hourly
        var newHourlyArr: [HourlyStub] = []
        
        if let uHourlyArr = hourlyArr {
            for (_, hItem) in uHourlyArr.enumerated() {
                let hour = hItem
                let newHWeather = WeatherStub(descript: hour.hWeather[0].descript)
                
                let newH = HourlyStub(hTime: Int(hour.hTime),
                                      hTemp: hour.hTemp,
                                      hWeather: [newHWeather])
                newHourlyArr.append(newH)
            }
        }
        
        let newForecast = ForecastStub(city: cModel?.name ?? "",
                                       country: cModel?.country ?? "",
                                       lat: fModel?.lat ?? 0,
                                       lon: fModel?.lon ?? 0,
                                       timezoneOffset: fModel?.timezoneOffset ?? 0,
                                       current: [newCurrent],
                                       daily: newDailyArr.sorted(by: { $0.dTime < $1.dTime }),
                                       hourly: newHourlyArr.sorted(by: { $0.hTime < $1.hTime }))
        completition(newForecast)
    }
    
    func takeWeatherForecast(_ coord: CLLocationCoordinate2D, comletition: @escaping (ForecastStub) -> Void) {
        self.dataModel.decodeModelFromData(coord) { fModel, cModel  in
            self.createCurrentForecastStub(fModel, cModel) { forecast in
                comletition(forecast)
            }
        }
    }
}
