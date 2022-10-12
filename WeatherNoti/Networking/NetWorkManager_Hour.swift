//
//  NetWorkManager_Hour.swift
//  WeatherNoti
//
//  Created by 김지수 on 2022/10/12.
//

import Foundation

extension NetworkManager {
 
    public func fetchHourWeatherData(date: String, time: String, nx: Int, ny: Int, completion: @escaping NetworkCompletion) {
        let urlString = "\(WeatherApi.requestUrl)\(WeatherApi.hourParam)?serviceKey=\(WeatherApi.serviceKey)&pageNo=1&numOfRows=1000&dataType=JSON&base_date=\(date)&base_time=\(time)&nx=\(nx)&ny=\(ny)"
        
        //http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?serviceKey=O%2FG920ZjfGIFYshoBYqghwh3hF22e6g9KOcQj6T2D1eAw6LqO18gKbSGOTmmvhyaVPkiQmnh3qQfhMNvU3A4YQ%3D%3D&pageNo=1&numOfRows=1000&dataType=JSON&base_date=20221011&base_time=1940&nx=55&ny=127
        
        performHourRequest(with: urlString) { result in
            completion(result)
        }
    }
    
    // 실제 Request하는 함수 (비동기적 실행 ===> 클로저 방식으로 끝난 시점을 전달 받도록 설계)
    private func performHourRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        //print(#function)
        guard let url = URL(string: urlString) else { return }
        print("네트워크 매니저의 url : \(url)")


        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            // 메서드 실행해서, 결과를 받음
            if let item = self.parseHourJSON(safeData) {
                print("Parse 실행")
                completion(.success(item))
            } else {
                
                print("Parse 실패")
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    // 받아본 데이터 분석하는 함수 (동기적 실행)
    private func parseHourJSON(_ hourWeatherData: Data) -> [HourWeatherItem]? {
        // 성공
        do {
            // 우리가 만들어 놓은 구조체(클래스 등)로 변환하는 객체와 메서드
            // (JSON 데이터 ====> MusicData 구조체)
            let hourWeatherData = try JSONDecoder().decode(HourWeatherData.self, from: hourWeatherData)
            return hourWeatherData.response.body.items.item
        // 실패
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
}
