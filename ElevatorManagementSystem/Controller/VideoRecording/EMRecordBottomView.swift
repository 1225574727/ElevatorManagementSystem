//
//  EMRecordBottomView.swift
//  ElevatorManagementSystem
//
//  Created by ts on 2021/11/5.
//

import UIKit
import SnapKit

typealias RecordButtonCallBack = (_ isStart: Bool) -> ()

class EMRecordBottomView: UIView{
    
    public var callBack: RecordButtonCallBack!
    
    lazy var recordButton: UIButton = {
        var btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        btn.setTitle("开始", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(recordButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        self.addSubview(recordButton)
        
        recordButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100);
            make.height.equalTo(40);
        }
    }
    
    @objc private func recordButtonClicked(recordBtn: UIButton) {
        if recordBtn.titleLabel?.text == "开始" {
            recordButton.setTitle("结束", for: .normal)
            if (callBack != nil) {
                callBack(true)
            }
        }else{
            recordButton.setTitle("开始", for: .normal)
            if (callBack != nil) {
                callBack(false)
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
