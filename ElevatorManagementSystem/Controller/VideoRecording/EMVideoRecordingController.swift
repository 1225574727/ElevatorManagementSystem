//
//  EMVideoRecordingController.swift
//  ElevatorManagementSystem
//
//  Created by ts on 2021/11/4.
//

import Foundation
import AVFoundation
import Photos
import UIKit
import AVKit

class EMVideoRecordingController: EMBaseViewController {
    
//    视频捕获会话，input和output之间的桥梁，协调input和output之间的数据传输
    let captureSession = AVCaptureSession()
//    视频输入设备，前后摄像头
    var camera: AVCaptureDevice?
//    展示界面
    var previewLayer: AVCaptureVideoPreviewLayer!
//    headerView
    var headerView: UIView!
    
//    音频输入设备
    let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
//    将捕获到的视频输入到文件
    let fileOut = AVCaptureMovieFileOutput()
    
//    录制按钮
    var recordButton: UIButton!
    
//    前后摄像头按钮
    var cameraFrontButton, cameraBackButton: UIButton!

//    录制时间Label
//    var totalTimeLabel: UILabel!
    
//    录制时间Timer
    var timer: Timer?
    var secondCount = 0
    
//    是否在录像中
    var isRecording = false
    
    
    
    //MARK:  LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAVFoundationSettings()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        totalTimeLabel.text = "00:00:00"
    }
    
    
    
    
    private func setupAVFoundationSettings() {
//        后置摄像头相机
        camera = cameraWithPosition(position: AVCaptureDevice.Position.back)
//        视频清晰度
        captureSession.sessionPreset = .high
        
//        添加视频，音频输入设备
        if let videoInput = try? AVCaptureDeviceInput(device: camera!) {
            captureSession.addInput(videoInput)
        }
        
        if audioDevice != nil,
           let audioInput = try? AVCaptureDeviceInput(device: audioDevice!){
            captureSession.addInput(audioInput)
        }
        
//        添加视频捕获输出
        self.captureSession.addOutput(fileOut)
        
//        使用 AVCaptureVideoPrevivewLayer 可以将摄像头拍到实时画面显示在ViewController上
        let videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        videoLayer.frame = view.bounds
        videoLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoLayer)
        
        previewLayer = videoLayer
        
//        启动Session会话
        self.captureSession.startRunning()
        
        
    }
    
    private func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        for item in devices {
            if item.position == position {
                return item
            }
        }
        return nil
    }
    
    //MARK:  UISettings
    private func setupUI(){
        
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(StatusBarHeight)
            make.width.height.equalTo(20)
        }
        
        view.addSubview(totalTimeLabel)
        
        totalTimeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(StatusBarHeight)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }

        
        let bottomView :EMRecordBottomView = EMRecordBottomView(frame: .zero)
        view.addSubview(bottomView)
        bottomView.callBack = { [weak self] isStart in
            if isStart {
                self?.beginRecord()
            }else{
                self?.endRecord()
            }
        }
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(100+HOME_INDICATOR_HEIGHT)
        }
        
    }
    //MARK:  lazy
    
    lazy var totalTimeLabel: UILabel = {
        var label: UILabel  = UILabel(frame: .zero)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 19)
        label.text = "00:00:00"
        return label
    }()
    
    lazy var backButton: UIButton = {
        var btn: UIButton = UIButton()
        btn.setBackgroundImage(UIImage(named: "iw_back"), for: .normal)
        btn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return btn
    }()


    //MARK:  recording
    private func beginRecord() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(videoRecordingTotalTime), userInfo: nil, repeats: true)
        
        if !isRecording {
            isRecording = true
            captureSession.startRunning()
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentDirectory = path[0] as String
            let filePath: String? = "\(documentDirectory)" + "/\(Date())" + ".mp4"
            let fileUrl: URL? = URL(fileURLWithPath: filePath!)
//            启动适配编码输出
            fileOut.startRecording(to: fileUrl!, recordingDelegate: self)
            
        }
    }
    
    private func endRecord() {
        timer?.invalidate()
        timer = nil
        secondCount = 0
        
        if isRecording {
            captureSession.stopRunning()
            isRecording = false
            
            
        }
        
    }
    
    
    
    @objc private func videoRecordingTotalTime() {
        secondCount += 1
        
        let hours = secondCount / 3600
        let mintues = (secondCount % 3600) / 60
        let seconds = secondCount % 60
        
        totalTimeLabel.text = String(format: "%02d", hours) + ":" + String(format: "%02d", mintues) + ":" + String(format: "%02d", seconds)
        
    }
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
}

extension EMVideoRecordingController: AVCaptureFileOutputRecordingDelegate {
//    开始录制
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
    }
    
//    结束录制
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        let player = AVPlayer(url: outputFileURL)
        let playerController = AVPlayerViewController()
        playerController.player = player
//        self.navigationController?.pushViewController(playerController, animated: true)
        self.navigationController?.present(playerController, animated: true, completion: nil)
    }
    
    
}
