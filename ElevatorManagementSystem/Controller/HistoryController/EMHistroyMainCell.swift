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

enum EMPageType {
    case elevatorCell
    case chooseRecordCell
    case detailRecordCell
}

struct RecordModel: HandyJSON {
    var timeText: String?
    var titleText: String?
    var checkText: String?
	var colorText: String?
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
        bgContentView.addSubview(leftDistanceLabel)
        bgContentView.addSubview(rightDistanceLabel)

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
        
        rightDistanceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-16)
            make.width.equalTo(80)
            make.height.equalTo(22)
        }
        
        leftDistanceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.rightDistanceLabel.snp.left).offset(-10)
            make.width.equalTo(80)
            make.height.equalTo(22)
        }
        
        
        
    }
    
    func updateCellData(model: RecordModel, type: EMPageType) {
        
        switch type {
        case .elevatorCell:
            self.bgContentView.image = UIImage(named: "manage_bg")
            titleLabel.text = model.titleText
            break
        case .chooseRecordCell:
            self.bgContentView.image = nil
            titleLabel.text = model.titleText
            timeLabel.text = model.timeText
            checkLabel.text = model.checkText
            break
        case .detailRecordCell:
            self.bgContentView.image = nil
            titleLabel.text = model.titleText
            let tempArr = model.checkText?.components(separatedBy: ",")
            if tempArr?.count == 2{
				
				let leftDistanceFloatValue = Float(tempArr![0]) ?? 0
				let rightDistanceFloatValue = Float(tempArr![1]) ?? 0

				leftDistanceLabel.text = "\(String(format: "\(leftDistanceFloatValue > 0 ? "+" : "")%.2f", leftDistanceFloatValue))mm"
                rightDistanceLabel.text = "\(String(format: "\(rightDistanceFloatValue > 0 ? "+" : "")%.2f", rightDistanceFloatValue))mm"
            }
			let colorArr = model.colorText?.components(separatedBy: ",")
			if colorArr?.count == 2{
				let leftColor = colorArr![0]
				let rightColor = colorArr![1]

				leftDistanceLabel.textColor = UIColor.init(hexString: leftColor)
				rightDistanceLabel.textColor = UIColor.init(hexString: rightColor)
			}
            break
        }
        
    }
    
    //MARK:  lazy
    private lazy var bgContentView:UIImageView = {
        let contentV = UIImageView()
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
    
    private lazy var leftDistanceLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.Green
        label.textAlignment = .center
        return label
    }()
    
    private lazy var rightDistanceLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.Main
        label.textAlignment = .center
        return label
    }()
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
