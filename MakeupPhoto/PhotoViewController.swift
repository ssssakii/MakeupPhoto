//
//  PhotoViewController.swift
//  MakeupPhoto
//
//  Created by SAKI TAKADA on 2017/09/30.
//  Copyright © 2017年 saki takada. All rights reserved.
//


import UIKit
import Accounts

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageIndex = 0
    // @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var backgroundImageView: UIImageView!
    var imageView = UIImageView()
    var height:CGFloat = 0
    var scale:CGFloat = 1.0
    var tapCount: Int = 0
    
    //加工前のイメージ
    var originalImage: UIImage!
    //フィルター
    var filter: CIFilter!
    
    // 画像の拡大率
    var currentScale:CGFloat = 1.0
    
    let imagenameArray: [String] = ["smiling.png", "happy (1).png", "happy (2).png", "happy (3).png", "happy.png", "in-love.png", "kissing.png", "tongue-out.png", "quiet.png", "angry.png", "mad.png", "confused.png", "unhappy.png", "crying.png","surprised.png", "smile.png", "bored.png", "wink.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFit
        // Do any additional setup after loading the view.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /***** スタンプのタッチ　*******/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //タッチされた位置取得
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self.view)
        
        
        if imageIndex != 0 {
            imageView = UIImageView(frame: CGRect(x: 0, y:0, width: 50, height: 50))
            print("photoVC->\(imageIndex)")
            let image: UIImage = UIImage(named: imagenameArray[imageIndex - 1])!
            imageView.image = image
            
            imageView.center = CGPoint(x: location.x, y: location.y)
            if (location.y < backgroundImageView.frame.midY*2-25) {
                self.view.addSubview(imageView)
                imageView.tag += 1
                /*
                 // imageViewにジェスチャーレコグナイザを設定する(ピンチ)
                 let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(sender:)))
                 imageView.addGestureRecognizer(pinchGesture)
                 */
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //タッチされた位置取得
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self.view)
        
        // 移動する前の座標を取得.
        let prevLocation = touch.previousLocation(in: self.view)
        
        // CGRect生成.
        var viewFrame: CGRect = imageView.frame
        
        // ドラッグで移動したx, y距離をとる.
        let deltaX: CGFloat = location.x - prevLocation.x
        let deltaY: CGFloat = location.y - prevLocation.y
        
        // 移動した分の距離をmyFrameの座標にプラスする.
        viewFrame.origin.x += deltaX
        viewFrame.origin.y += deltaY
        
        imageView.frame = viewFrame
        
        
        if (location.y < backgroundImageView.frame.midY*2-25) {
            // frameにmyFrameを追加.
            self.view.addSubview(imageView)
            imageView.tag += 1
            /*
             // imageViewにジェスチャーレコグナイザを設定する(ピンチ)
             let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(sender:)))
             imageView.addGestureRecognizer(pinchGesture)
             */
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    /***** 戻るボタン　******/
    @IBAction func back() {
        self.imageView.removeFromSuperview()
    }
    
    /****** 背景を選ぶ　******/
    @IBAction func selectBackground() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            picker.allowsEditing = true
            //フォトライブラリを呼び出す
            self.present(picker, animated: true, completion:  nil)
        }
    }
    
    /***** カメラ *****/
    @IBAction func takePhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        } else {
            print("error")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        backgroundImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        originalImage = backgroundImageView.image
        
        //フォトライブラリを閉じる
        dismiss(animated: true, completion: nil)
        
    }
    
    /******　カラーフィルター ********/
    
    @IBAction func colorFilter() {
        // タップ回数を加算
        self.tapCount += 1
        
        //let filterImage: CIImage = CIImage(image: originalImage)!
        
        // 用意した文字の数をタップ回数が超えている場合
        if (2 < self.tapCount) {
            tapCount = 0
            backgroundImageView.image = originalImage
        } else {
            // タップ回数に応じたフィルターに更新
            self.updateFilter(index: self.tapCount)
        }
    }
    
    func updateFilter(index: Int) {
        // image が 元画像のUIImage
        let ciImage:CIImage = CIImage(image: originalImage)!
        var ciFilter = CIFilter()
        print("FilterIndex\(index)")
        switch index {
        case 1:
            //セピア調
            ciFilter = CIFilter(name: "CISepiaTone")!
            ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
            ciFilter.setValue(0.8, forKey: "inputIntensity")
            break
        case 2:
            //白黒
            ciFilter = CIFilter(name: "CIColorMonochrome")!
            ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
            ciFilter.setValue(CIColor(red: 0.75, green: 0.75, blue: 0.75), forKey: "inputColor")
            ciFilter.setValue(1.0, forKey: "inputIntensity")
            break
        default:
            break
            
        }
        let ciContext:CIContext = CIContext(options: nil)
        let cgimg:CGImage = ciContext.createCGImage(ciFilter.outputImage!, from:ciFilter.outputImage!.extent)!
        
        //image2に加工後のUIImage
        let image2:UIImage = UIImage(cgImage: cgimg, scale: 1.0, orientation:UIImageOrientation.up)
        backgroundImageView.image = image2
        
    }
    
    
    /*******　セーブ　********/
    @IBAction func save() {
        //スクショ
        let rect: CGRect = CGRect(x: 0, y: backgroundImageView.frame.height+64, width: 375, height: 375)
        UIGraphicsBeginImageContext(rect.size)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let capture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        // アラート
        let alertController: UIAlertController =
            UIAlertController(title: "保存",
                              message: "この画像を保存しますか？",
                              preferredStyle: .alert)
        
        // 選択肢
        let actionOK = UIAlertAction(title: "OK", style: .default){
            action in
            //保存
            UIImageWriteToSavedPhotosAlbum(capture!, nil, nil, nil)
            
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel){
            (action) -> Void in
        }
        
        // actionを追加
        alertController.addAction(actionOK)
        alertController.addAction(actionCancel)
        
        // UIAlertControllerの起動
        present(alertController, animated: true, completion: nil)
        
    }
    
    /******** SNS *********/
    @IBAction func postSNS(){
        let shareText = "写真加工したよ"
        
        let shareImage = backgroundImageView.image
        
        //投稿するコメントと画像の準備
        let activityItems: [Any] = [shareText, shareImage]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let excludedActivityTypes = [UIActivityType.postToWeibo, .saveToCameraRoll, .print]
        
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    
    
}
