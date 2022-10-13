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
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var hourCollectionView: UICollectionView!
    
    private var currentDataManager = CurrentDataManager()
    private var shortDataManager = ShortDataManager()
    private var networkManager = NetworkManager.shared
    private var skyIconManager = SkyIconManager()
    
    private var shortData: [ShortWeatherModel] = []
    // 컬렌션뷰의 레이아웃 담당 객체
    private var flowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInit()
        setupCollectionViewLayout()
        currentDataManager.setupCurrentNetworks()
        shortDataManager.setupShortNetworks()
    }
    
    // 초기 한번 데이터 세팅
    func setupInit() {
        hourCollectionView.delegate = self
        hourCollectionView.dataSource = self
        view.backgroundColor = UIColor(red: 16, green: 16, blue: 59, a: 255)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchShortNetworkUI(_:)), name: .shortWeatherData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchCurrentNetworkUI(_:)), name: .currentWeatherData, object: nil)
    }
    
    // CurrentDataManager에서 완료된 데이터를 받음
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
    // ShortDataManager에서 완료된 데이터를 받음
    @objc func fetchShortNetworkUI(_ data: Notification) {

        if let shortModel = data.object as? [ShortWeatherModel] {
            self.shortData = shortModel
            self.hourCollectionView.reloadData()
        }
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
    
    @IBAction func tempButtonTapped(_ sender: Any) {
        currentDataManager.setupCurrentNetworks()
        shortDataManager.setupShortNetworks()
    }

    
}

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
