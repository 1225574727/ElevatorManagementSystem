//
//  EMHistroyMainCell.swift
//  ElevatorManagementSystem
//
//  Created by ts on 2021/12/11.
//

import UIKit
import SwiftUI
import HandyJSON

enum CheckStyle {
    case nomal
    case afterCalibration
    case beforeCalibration
    
    var checkText: String {
        switch self {
        case .nomal:
            return "正常检查"
        case .afterCalibration:
            return "校准前"
        case .beforeCalibration:
            return "校准后"
        }
    }
}

struct RecordModel: HandyJSON {
    var timeText: String?
    var titleText: String?
    var checkText: String?
}


class EMHistroyMainCell: UITableViewCell {
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.origin.x = 11
            frame.size.width = frame.size.width - 22
            super.frame = frame
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        initSubView()
    }
    
    private func initSubView() {
        
        self.addSubview(bgContentView)
        bgContentView.addSubview(titleLabel)
        bgContentView.addSubview(checkLabel)
        bgContentView.addSubview(timeLabel)

        bgContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
            make.right.equalTo(-16)
            make.height.equalTo(22)
        }
        
        checkLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(22)
            make.width.equalTo(200)

        }
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-15)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(22)
        }
    }
    
    func updateCellData(model: RecordModel) {
        titleLabel.text = model.titleText
        timeLabel.text = model.timeText
        checkLabel.text = model.checkText
    }
    
    //MARK:  lazy
    private lazy var bgContentView:UIView = {
        let contentV = UIView()
        contentV.backgroundColor = UIColor.colorFormHex(0xFDF7F7)
        contentV.layer.cornerRadius = 8
        contentV.layer.masksToBounds = true
        return contentV
    }()
    
    private lazy var titleImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.B3
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.B9
        label.textAlignment = .right
        return label
    }()
    
    private lazy var checkLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.B3
        label.textAlignment = .right
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
