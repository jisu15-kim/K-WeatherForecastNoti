//
//  WeatherViewController.swift
//  WeatherNoti
//
//  Created by 김지수 on 2022/10/10.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentDegreeLabel: UILabel!
    @IBOutlet weak var shortLocateLabel: UILabel!
    @IBOutlet weak var feelingDegreeLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var hourCollectionView: UICollectionView!
    
    var hourDataManager = HourDataManager()
    var networkManager = NetworkManager.shared
    var userInfo = UserInfo.shared
    var hourData: [HourWeatherModel] = []
    var hourWeatherData: [HourWeatherItem] = []
    var currentData: CurrentWeatherModel?
    // 컬렌션뷰의 레이아웃 담당 객체
    var flowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInit()
        setupData()
        setupCollectionViewLayout()
        setupNetworks()
    }
    
    // 초기 한번 데이터 세팅
    func setupInit() {
        hourDataManager.fetchHourData()
        hourCollectionView.delegate = self
        hourCollectionView.dataSource = self
        view.backgroundColor = UIColor(red: 16, green: 16, blue: 59, a: 255)
    }
    
    func setupData() {
        hourData = hourDataManager.getHourData()
    }
    
    func setupCollectionViewLayout() {
        flowLayout.scrollDirection = .horizontal
        let cellWidth = hourCollectionView.frame.width / 4 - 20
        flowLayout.itemSize = CGSize(width: cellWidth, height: hourCollectionView.frame.height - 20)
        // 아이템 사이 간격 설정
        flowLayout.minimumLineSpacing = 5
        
        // 컬렉션뷰의 속성에 할당
        hourCollectionView.collectionViewLayout = flowLayout
    }
    
    private func setupNetworks() {
        let today = userInfo.getCurrentDate()
        let now = userInfo.getCurrentTime()
//        let today = "20221011"
//        let now = "1940"
        let nx = 55
        let ny = 127
        
        networkManager.fetchCurrentWeatherData(date: today, time: now, nx: nx, ny: ny) { result in
            //print("VC의 네트워크매니저 FetchData 실행")
            switch result {
            case .success(let successedData):
                self.hourWeatherData = successedData
                // currentData 구조체로 요약 및 생성
                self.processData(array: successedData)
                
                // 비동기 (네트워크 처리 이후 실행되는 코드)
                DispatchQueue.main.async {
                    self.setupCurrentUI()
                    dump(self.hourWeatherData)
                    self.hourCollectionView.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        networkManager.fetchCurrentWeatherData(date: today, time: now, nx: nx, ny: ny) { result in
            //print("VC의 네트워크매니저 FetchData 실행")
            switch result {
            case .success(let successedData):
                self.hourWeatherData = successedData
                // currentData 구조체로 요약 및 생성
                self.processData(array: successedData)
                
                // 비동기 (네트워크 처리 이후 실행되는 코드)
                DispatchQueue.main.async {
                    self.setupCurrentUI()
                    dump(self.hourWeatherData)
                    self.hourCollectionView.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func processData(array: [HourWeatherItem]) {
        var data: [String:String] = [:]
        for item in array {
            data.updateValue(item.obsrValue ?? "", forKey: item.category ?? "")
        }
        dump("딕셔너리: \(data)")
        currentData = CurrentWeatherModel(pty: data["PTY"]!, reh: data["REH"]!, rn1: data["RN1"]!, t1h: data["T1H"]!, uuu: data["UUU"]!, vec: data["VEC"]!, vvv: data["VVV"]!, wsd: data["WSD"]!)
    }
    
    @IBAction func tempButtonTapped(_ sender: Any) {
        setupNetworks()
    }
    
    func setupCurrentUI() {
        currentDegreeLabel.text = currentData?.t1h
        
    }
    
}

extension WeatherViewController: UICollectionViewDelegate {
    
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = hourCollectionView.dequeueReusableCell(withReuseIdentifier: "HourWeatherCell", for: indexPath) as! HourWeatherCell
        let data = hourData[indexPath.row]
        
        //print(data)
        
        cell.hourImage.image = data.image
        cell.hourLabel.text = "\(data.time)AM"
        cell.hourDegree.text = String(data.degree)
        
        cell.layer.borderWidth = 2 // rgba(37,37,78,255)
        cell.layer.borderColor = CGColor(red: 37/255, green: 37/255, blue: 78/255, alpha: 255/255)
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.layer.backgroundColor = CGColor(red: 30/255, green: 31/255, blue: 69/255, alpha: 255/255)
        return cell
    }
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    // let's suppose alpha is the first component (ARGB)
    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF,
            a: (argb >> 24) & 0xFF
        )
    }
}
