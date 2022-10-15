//
//  NetworkManager.swift
//  WeatherNoti
//
//  Created by 김지수 on 2022/10/11.
//


import Foundation

extension NetworkManager {
    
    typealias DaysWeatherCompletion = (Result<[DaysWeatherItem], NetworkError>) -> Void
    
    public func fetchDaysWeatherData(date: String, time: String, nx: Int, ny: Int, completion: @escaping DaysWeatherCompletion) {
        let urlString = "\(WeatherApi.daysRequestUrl)?serviceKey=\(WeatherApi.daysServiceKey)&pageNo=1&numOfRows=1000&dataType=JSON&regId=11B10101&tmFc=\(time)"
        
        //https://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa?serviceKey=O%2FG920ZjfGIFYshoBYqghwh3hF22e6g9KOcQj6T2D1eAw6LqO18gKbSGOTmmvhyaVPkiQmnh3qQfhMNvU3A4YQ%3D%3D&pageNo=1&numOfRows=1000&dataType=JSON&regId=11B10101&tmFc=202210141800
        
        performdaysRequest(with: urlString) { result in
            completion(result)
        }
    }
    
    // 실제 Request하는 함수 (비동기적 실행 ===> 클로저 방식으로 끝난 시점을 전달 받도록 설계)
    private func performdaysRequest(with urlString: String, completion: @escaping DaysWeatherCompletion) {
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
            if let item = self.parsedaysJSON(safeData) {
                completion(.success(item))
            } else {
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    // 받아본 데이터 분석하는 함수 (동기적 실행)
    private func parsedaysJSON(_ daysWeatherData: Data) -> [DaysWeatherItem]? {
        // 성공
        do {
            // 우리가 만들어 놓은 구조체(클래스 등)로 변환하는 객체와 메서드
            // (JSON 데이터 ====> MusicData 구조체)
            let daysWeatherData = try JSONDecoder().decode(DaysWeatherData.self, from: daysWeatherData)
            return daysWeatherData.response.body.items.item
            // 실패
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
}
