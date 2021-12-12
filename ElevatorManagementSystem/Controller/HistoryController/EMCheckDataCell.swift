//
//  EMCheckDataCell.swift
//  ElevatorManagementSystem
//
//  Created by 姚李刚 on 2021/12/12.
//

import UIKit
import Kingfisher

class EMCheckDataCell: UITableViewCell {
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.origin.x = 20
            frame.size.width = frame.size.width - 40
            super.frame = frame
        }
    }
    
    //MARK:  lazy
    private lazy var bgContentView: UIView = {
        let contentV = UIView()
        contentV.backgroundColor = UIColor.white
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.GrayLine.cgColor
        return contentV
    }()
    
    private var imageV: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = .Main
        return imgV
    }()
    
    private lazy var descTextLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.B3
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        initSubView()
    }
    
    private func initSubView() {
        self.addSubview(self.bgContentView)
        self.bgContentView.addSubview(self.imageV)
        self.bgContentView.addSubview(self.descTextLabel)
        
        self.bgContentView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(1)
            make.bottom.right.equalTo(-1)
        }
        
        self.imageV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(210)

//            make.height.equalTo(self.frame.width*0.62)
        }
        
        self.descTextLabel.snp.makeConstraints { make in
            make.top.equalTo(self.imageV.snp.bottom).offset(12)
            make.left.equalTo(12)
            make.right.bottom.equalTo(-12)
        }
        

    }
    
    func updateData(imageUrl: String) -> Void {
        let paraph = NSMutableParagraphStyle()
        //将行间距设置为28
        paraph.lineSpacing = 4
        //样式属性集合
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12),
                          NSAttributedString.Key.paragraphStyle: paraph]
        self.descTextLabel.attributedText = NSAttributedString(string: "这是一段文本，这是一段文本，这是一段文本，这是一段文 本，这是一段文本，这是一段文本，这是一段文本，这是一 段文本。", attributes: attributes)
        self.imageV.kf.setImage(with: URL(string: imageUrl))
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
}
