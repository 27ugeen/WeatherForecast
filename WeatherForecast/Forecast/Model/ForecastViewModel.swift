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


class ForecastViewModel {
    //MARK: - props
    private let dataModel: ForecastDataModel
    
    var forecast: ForecastStub?
    
    //MARK: - init
    init(dataModel: ForecastDataModel) {
        self.dataModel = dataModel
    }
    //MARK: - methods
    func createCurrentForecastStub(_ fModel: ForecastModel?, _ cModel: NameCityModel?, completition: @escaping (ForecastStub) -> Void) {
        
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
//        forecasts.append(newForecast)
        forecast = newForecast
        completition(newForecast)
    }
    
    func takeWeatherForecast(_ coord: CLLocationCoordinate2D, comletition: @escaping (ForecastModel, NameCityModel) -> Void) {
        self.dataModel.decodeModelFromData(coord) { fModel, cModel  in
            print("from vm \(cModel)")
            comletition(fModel, cModel)
        }
    }
}
