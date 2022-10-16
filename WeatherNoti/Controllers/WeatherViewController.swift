//
//  WeatherViewController.swift
//  WeatherNoti
//
//  Created by 김지수 on 2022/10/10.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentDegreeLabel: UILabel!
    @IBOutlet weak var shortLocateLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var hourCollectionView: UICollectionView!
    @IBOutlet weak var daysTableView: UITableView!
    
    private var currentDataManager = CurrentDataManager()
    private var shortDataManager = ShortDataManager()
    private var daysDataManager = DaysDataManager()
    
    var gpsManager = GPSManager.shared
    private var networkManager = NetworkManager.shared
    private var skyIconManager = SkyIconManager()
    private var userInfo = UserInfo.shared
    
    private var todayModel: TodayModel?
    private var shortData: [ShortWeatherModel] = []
    private var daysData: [DaysWeatherModel] = []
    // 컬렌션뷰의 레이아웃 담당 객체
    private var flowLayout = UICollectionViewFlowLayout()
    
    private let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    
    var latitude: Double?
    var longitude: Double?
    var nx: Int?
    var ny: Int?
    var locationManager: CLLocationManager = CLLocationManager() // location manager
    var currentLocation: CLLocation! // 내 위치 저장
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInit()
        setupCollectionViewLayout()
        setupCurrentUI()
        setupNotificationCenter()
        getLocationInfo()
    }
    
    // 초기 한번 데이터 세팅
    private func setupInit() {
        hourCollectionView.delegate = self
        hourCollectionView.dataSource = self
        daysTableView.delegate = self
        daysTableView.dataSource = self
        view.backgroundColor = UIColor(red: 16, green: 16, blue: 59, a: 255)
    }
    
    private func getLocationInfo(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
//        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            print("GPS 받으러 갑니다")
        }else{
            print("GPS를 못받아왔어요")
        }
        locationManager.startUpdatingLocation()
        
    }
    
    func fetchData() {
        currentDataManager.setupCurrentNetworks(nx: nx!, ny: ny!)
        shortDataManager.setupShortNetworks(nx: nx!, ny: ny!)
        daysDataManager.setupDaysNetworks()
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchShortNetworkUI(_:)), name: .shortWeatherData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchCurrentNetworkUI(_:)), name: .currentWeatherData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchDaysNetworkUI(_:)), name: .daysWeatherData, object: nil)
    }
    
    private func setupCurrentUI() {
        todayModel = userInfo.getCurrentTitleDate() // 오늘 정보 받아와 업데이트
        guard let safeModel = todayModel else { return }
        dateLabel.text = "\(safeModel.month) \(safeModel.date)일 \(safeModel.dayOfWeek)요일"
    }
    
    // MARK: - 컬렉션뷰 UI 세팅 - Short
    private func setupCollectionViewLayout() {
        flowLayout.scrollDirection = .horizontal
        let cellWidth = hourCollectionView.frame.width / 4 - 20
        flowLayout.itemSize = CGSize(width: cellWidth, height: hourCollectionView.frame.height - 20)
        // 아이템 사이 간격 설정
        flowLayout.minimumLineSpacing = 5
        
        // 컬렉션뷰의 속성에 할당
        hourCollectionView.collectionViewLayout = flowLayout
    }
    
    // MARK: - 네트워크 데이터 수신 및 UI 세팅
    // CurrentDataManager에서 완료된 데이터를 받아서 UI 세팅
    @objc func fetchCurrentNetworkUI(_ data: Notification) {
        
        if let currentModel = data.object as? CurrentWeatherModel {
            
            let pty = Int(currentModel.pty)!
            var time = currentModel.time
            let intTime = Int(time)!
            // 아이콘 추출하는 함수로 들어감
            let icon = skyIconManager.currentSkyIconLogic(pty: pty, time: intTime)
            self.currentDegreeLabel.text = currentModel.t1h
            self.currentWeatherImage.image = icon
            
            // 시간 중간에 : 넣기
            time.insert(contentsOf: ":", at: time.index(time.startIndex, offsetBy: 2))
            self.updateTimeLabel.text = "\(time) 업데이트 기준"
        }
    }
    // ShortDataManager에서 완료된 데이터를 받아서 UI 세팅
    @objc func fetchShortNetworkUI(_ data: Notification) {
        
        if let shortModel = data.object as? [ShortWeatherModel] {
            self.shortData = shortModel
            self.hourCollectionView.reloadData()
        }
    }
    // DaysDataManager에서 완료된 데이터를 받아서 UI 세팅
    @objc func fetchDaysNetworkUI(_ data: Notification) {
        
        if let daysModel = data.object as? [DaysWeatherModel] {
            self.daysData = daysModel
            self.daysTableView.reloadData()
        }
    }

    // MARK: - Refersh 버튼 클릭
    @IBAction func tempButtonTapped(_ sender: Any) {
        fetchData()
    }
}

// MARK: - UI 컬렉션뷰 세팅 - Short

extension WeatherViewController: UICollectionViewDelegate {
    
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shortData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = hourCollectionView.dequeueReusableCell(withReuseIdentifier: "HourWeatherCell", for: indexPath) as! HourWeatherCell
        let data = shortData[indexPath.row]
        let skyData = Int(data.sky)!
        let ptyData = Int(data.pty)!
        let time = Int(data.time)!
        
        // 아이콘 정보 받아오는 로직
        let icon = skyIconManager.shortSkyIconLogic(sky: skyData, pty: ptyData, time: time)
        
        // 텍스트 변환
        var stringTime = String(time)
        if time != 0 {
            stringTime.removeLast(2)
            stringTime.append("시")
        } else {
            stringTime = "0시"
        }
        
        // 데이터 전달
        cell.hourImage.image = icon
        cell.hourLabel.text = stringTime
        cell.hourDegree.text = data.temp
        
        cell.layer.borderWidth = 2 // rgba(37,37,78,255)
        cell.layer.borderColor = CGColor(red: 37/255, green: 37/255, blue: 78/255, alpha: 255/255)
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.layer.backgroundColor = CGColor(red: 30/255, green: 31/255, blue: 69/255, alpha: 255/255)
        return cell
    }
}

// MARK: - UI 테이블뷰 세팅 - Days
extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = daysTableView.dequeueReusableCell(withIdentifier: "DaysWeatherCell", for: indexPath) as! DaysWeatherCell
        let data = daysData[indexPath.row]
        
        // 0 = 3일뒤, 1 = 4일뒤
        let dayOfWeek = Date().dayofTheWeek(input: indexPath.row + 3)
        
        cell.dayLabel.text = "\(dayOfWeek)"
        cell.highTempLabel.text = "\(data.high)℃"
        cell.lowTempLabel.text = "\(data.low)℃"
        
        return cell
    }
}

