//
//  ViewController.swift
//  DailyRecord
//
//  Created by jimin on 2022/04/06.
//. 22.04.12 깃 업로드!!

import UIKit
import FSCalendar
import Foundation
import RealmSwift


class ViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate{
    
    // Realm 가져오기
    let realm = try! Realm()

    @IBOutlet var calendar: FSCalendar!
    
    
    
    @IBOutlet var imageView: UIImageView!
    let myImage: UIImage = UIImage(named: "cat.jpg")!
    let imagePickerController = UIImagePickerController()
    
    var events = [Date]()
    let currentCalendar = Calendar.current
    lazy var currentPage = calendar.currentPage
    let alertController = UIAlertController(title: "올릴 방식을 선택하세요", message: "사진 찍기 또는 앨범에서 선택", preferredStyle: .actionSheet)
    
    var imageCheck = false
 
    //private var currentPage: Date?
    private lazy var today: Date = { return Date() }()

    fileprivate let datesWithCat = ["20220407"]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //calendar.allowsMultipleSelection = true
        calendar.delegate = self
        calendar.dataSource = self
        
        calendarStyle()
        setUpEvents()
        
        imageView.image = myImage
        
        enrollAlertEvent()
        
        addGestureRecognizer()
        


        // Realm 파일 위치
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // 데이터 타입 클래스를 선언하고, 저장할 year/month/day를 각각 지정합니다.
        let dateSelected = ImageInfo()
        dateSelected.year = "2022"
        dateSelected.month = "04"
        dateSelected.day = "07"
        
//        // Realm 에 저장하기
//        try! realm.write {
//            realm.add(dateSelected)
//            //안의 데이터 전부 삭제
//            realm.deleteAll()
//        }
//
//        // Person 가져오기
//        let imageInfo = realm.objects(ImageInfo.self)
//        print(imageInfo)

          save()

        
        
    }
    
    func saveImageInfo(_ year:String,_ month:String,_ day:String) -> ImageInfo {
        let imageinfo = ImageInfo()
        imageinfo.year = year
        imageinfo.month = month
        imageinfo.day = day
        
        return imageinfo
    }
    
    func save(){
        let 빈지노 = self.saveImageInfo("Beenzino","34","남")
         let 나플라 = self.saveImageInfo("Nafla", "29","남")
           let 윤미래 = self.saveImageInfo("Tasha","40","여")
         
         try! realm.write{
             realm.add(빈지노)
             realm.add(나플라)
             realm.add(윤미래)
         }
        print("저장되었습니다.")
    }
    
    func deletedata(_ sender: Any) {
        let userinfo = realm.objects(ImageInfo.self)
            
                      try! realm.write {
                          realm.delete(userinfo)
                      }
               
                  
        }

    
    func enrollAlertEvent() {
            let photoLibraryAlertAction = UIAlertAction(title: "사진 앨범", style: .default) {
                (action) in
                self.openAlbum() // 아래에서 설명 예정.
            }
            let cameraAlertAction = UIAlertAction(title: "카메라", style: .default) {(action) in
                self.openCamera() // 아래에서 설명 예정.
            }
            let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            self.alertController.addAction(photoLibraryAlertAction)
            self.alertController.addAction(cameraAlertAction)
            self.alertController.addAction(cancelAlertAction)
            guard let alertControllerPopoverPresentationController
                    = alertController.popoverPresentationController
            else {return}
            prepareForPopoverPresentation(alertControllerPopoverPresentationController)
    }
    
    func openAlbum() {
            self.imagePickerController.sourceType = .photoLibrary
            present(self.imagePickerController, animated: false, completion: nil)
    }
    
    func openCamera() {
           if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
               self.imagePickerController.sourceType = .camera
               present(self.imagePickerController, animated: false, completion: nil)
           }
           else {
               print ("Camera's not available as for now.")
           }
       }
    
    @objc func tappedUIImageView(_ gesture: UITapGestureRecognizer) {
            self.present(alertController, animated: true, completion: nil)
    }
    

    
    func addGestureRecognizer() {
            let tapGestureRecognizer
      = UITapGestureRecognizer(target: self,
                               action: #selector(self.tappedUIImageView(_:)))
            self.imageView.addGestureRecognizer(tapGestureRecognizer)
            self.imageView.isUserInteractionEnabled = true
    }
    
    func calendarStyle(){
        
        //언어 한국어로 변경
        calendar.locale = Locale(identifier: "ko_KR")

        // 헤더의 날짜 포맷 설정
        calendar.appearance.headerDateFormat = "YYYY년 MM월"

        // 헤더의 폰트 색상 설정
        calendar.appearance.headerTitleColor = .black

        // 헤더의 폰트 정렬 설정
        // .center & .left & .justified & .natural & .right
        calendar.appearance.headerTitleAlignment = .center
        
        //헤더 폰트
        calendar.appearance.headerTitleFont = UIFont(name: "NotoSansKR-Medium", size: 16)
        //weekday 폰트
        calendar.appearance.weekdayFont = UIFont(name: "NotoSansKR-Regular", size: 14)
        //날짜 폰트
        calendar.appearance.titleFont = UIFont(name: "NotoSansKR-Regular", size: 10)
        

        // 헤더 높이 설정
        calendar.headerHeight = 45

        // 헤더 양 옆(전달 & 다음 달) 글씨 투명도
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0   // 0.0 = 안보이게 됩니다.
        
        // 선택된 날짜 모서리 설정
        calendar.appearance.borderRadius = 0

        //MARK: -캘린더(날짜 부분) 관련
        calendar.backgroundColor = .white
        // 배경색
        calendar.appearance.weekdayTextColor = .systemPink
        //요일(월,화,수..) 글씨 색
        calendar.appearance.selectionColor = .orange
        //선택 된 날의 동그라미 색
        calendar.appearance.titleWeekendColor = .orange
        //주말 날짜 색
        calendar.appearance.titleDefaultColor = .gray
        //기본 날짜 색

        //스크롤 가능여부
        calendar.scrollEnabled = false

        // 다중 선택
        //calendar.allowsMultipleSelection = true

        // 꾹 눌러서 드래그 동작으로 다중 선택
        //calendar.swipeToChooseGesture.isEnabled = true
        
        calendar.appearance.eventDefaultColor = UIColor.green
        calendar.appearance.eventSelectionColor = UIColor.orange

    }
    
    //특정 날짜에 주석 달기
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let dateFromatter = DateFormatter()
        dateFromatter.dateFormat = "yyyyMMdd"
        switch dateFromatter.string(from: date){
        case dateFromatter.string(from: Date()):
            return "오늘"
        case "20220411":
            return "다이어트"
        default:
            return nil
        }
    }
    
    //스와이프
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.currentPage = calendar.currentPage
    }
 

    // 날짜 선택 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        print(dateFormatter.string(from: date))
        if imageCheck == true{
            imageView.image = UIImage(named: "cat2.png")
            imageCheck = false
        }
        else{
            imageView.image = UIImage(named: "cat.jpg")
        }
    }
 
    // 날짜 선택 해제 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        print(dateFormatter.string(from: date))
    }

    @IBAction func moveToPrev(_ sender: Any) {
        self.moveCurrentPage(moveUp: false)


    }
    @IBAction func moveToNext(_ sender: Any) {
        self.moveCurrentPage(moveUp: true)

    }

    //MARK: -사용자 정의 함수
    private func moveCurrentPage(moveUp: Bool) {
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1
        self.currentPage = currentCalendar.date(byAdding: dateComponents, to: self.currentPage)!
        self.calendar.setCurrentPage(self.currentPage, animated: true)

}
    //이벤트 표시
    func setUpEvents() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy-MM-dd"
    let xmas = formatter.date(from: "2022-04-07")
    let sampledate = formatter.date(from: "2022-04-08")
    events = [xmas!, sampledate!]
    }

    //출처: https://ahyeonlog.tistory.com/7 [사과농장]

    //이벤트 표시 개수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    if self.events.contains(date) {
    return 1
    } else {
    return 0
    }
    }

    // 특정 날짜에 이미지 세팅
     func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
         let imageDateFormatter = DateFormatter()
         imageDateFormatter.dateFormat = "yyyyMMdd"
         let dateStr = imageDateFormatter.string(from: date)
         print("date : \(dateStr)")
         



         //myImage.resizeImgageTo(size: <#T##CGSize#>)
         let imageSize = CGSize(width: 50, height: 50)
         
         switch imageDateFormatter.string(from: date){
         case imageDateFormatter.string(from: Date()):
             imageCheck = true
             print("imageCheck : \(imageCheck)")

             return UIImage(named: "cat2.png")?.resizeImgageTo(size: imageSize)
         case "20220411":
             return UIImage(named: "cat.jpg")?.resizeImgageTo(size: imageSize)
         default:
             return nil
         }
         //return datesWithCat.contains(dateStr) ? UIImage(named: "cat") : nil
         }


   
    //캘린더 클릭시 이벤트
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//        guard let modalPresentView = self.storyboard?.instantiateViewController(identifier: "TestViewController") as? TestViewController else { return }
//        // 날짜를 원하는 형식으로 저장하기 위한 방법입니다.
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        modalPresentView.date = dateFormatter.string(from: date)
//        self.present(modalPresentView, animated: true, completion: nil)
//
//    }
    //출처: https://icksw.tistory.com/122 [PinguiOS]
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[UIImagePickerController.InfoKey.originalImage]
//                as? UIImage {
//                imageView?.image = image
//            }
//            else {
//                print("error detected in didFinishPickinMediaWithInfo method")
//            }
//            dismiss(animated: true, completion: nil) // 반드시 dismiss 하기.
//        }

}

extension UIImage {
    func resizeImgageTo(size: CGSize) -> UIImage{

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}





extension ViewController: UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        if let popoverPresentationController =
      self.alertController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect
            = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage{
            imageView.image = image
            
            print(info)
        }
        dismiss(animated: true, completion: nil)
    }
}
