# K-Weather Forecast APP
한국 기상청 일기예보 앱 for learning (Network)

# 한국 기상청 일기예보 앱

* GPS와 네트워크 데이터 Request(read)에 대한 이해와 실습을 하기 위한 앱
* MVC 패턴

## 목적

* 무료 공개 API를 활용해 네트워크가 적용된 앱 제작 실습
* 테이블뷰와 컬렉션뷰의 활용


## 개요

* 개발기간: 22.10.10 ~ 22.10.16

<div width="100%">
<img width="600" alt="스크린샷 2022-10-22 20 17 04" src="https://user-images.githubusercontent.com/108998071/197336146-654d0b65-8875-477f-975f-6f6af8068af4.png">
<img src="https://user-images.githubusercontent.com/108998071/197337271-a32ff0bc-b985-4b9c-8e46-868952b4ccfa.gif" width="48%"/>
<img src="https://user-images.githubusercontent.com/108998071/197337275-55f66831-21a5-4ccc-aaaa-89374debf600.gif" width="48%"/>
</div>

## 문제와 해결

* 서버에서 주는 json 데이터와 내가 원하는 데이터 모델에 차이가 있음
  * dataProcessing() 함수를 만들어서 원하는 데이터 모델을 반환하도록 함
  * for와 if를 적절히 활용한 로직을 만듬
  * 이때, 시간을 들여 알고리즘에 대한 고민을 많이 하게 되고, 공부가 필요함을 느끼게 됨
  
* 네트워크 수신의 비동기 처리와 그 이후의 동작들에 대한 고민
  * 네트워크 수신이 되지 않았을 때, Indicator를 표시하기 원하는 상황
  * **NotificationCenter**를 활용해 수신이 완료됨을 체크하고, 수신된 데이터 모델을 전달함
  
### 기타 배운 것
  * Date, Calender
  * CoreLocation(CLLocationManager)
  * 데이터 처리 순서에 대한 고민
  
## 느낀점
* 서버의 데이터와 내가 원하는 데이터 모델에 차이가 있어 적절한 로직의 구현을 고민하는데 시간을 많이 들이게 되었다.
* 또한, 시간과 날씨 데이터를 통해 적절한 날씨 이모티콘을 반환하는 로직도 구현했다.
* 원하는 데이터를 구현하는데 성공했지만, 알고리즘 공부의 필요를 더욱 느끼게 되었다.
* 다음 프로젝트에서는 더욱 복잡한 UI를 구현하는 연습을 해야겠다.🔥
