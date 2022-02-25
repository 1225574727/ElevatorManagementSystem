//
//  EMCheckDataCell.swift
//  ElevatorManagementSystem
//
//  Created by ylg on 2021/12/12.
//

import UIKit
//import Kingfisher

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
    
//    private var imageV: UIImageView = {
//        let imgV = UIImageView()
////        imgV.backgroundColor = .gray
//        return imgV
//    }()
    
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
//        self.bgContentView.addSubview(self.imageV)
        self.bgContentView.addSubview(self.descTextLabel)
        
        self.bgContentView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(1)
            make.bottom.right.equalTo(-1)
        }
        
//        self.imageV.snp.makeConstraints { make in
//            make.left.right.top.equalToSuperview()
//            make.height.equalTo(210)
//
////            make.height.equalTo(self.frame.width*0.62)
//        }
        
        self.descTextLabel.snp.makeConstraints { make in
            make.height.equalTo(82)
            make.left.equalTo(12)
            make.right.bottom.equalTo(-12)
        }
        

    }
    
    func updateData(urlArray: [String],content: String?) -> Void {
        let paraph = NSMutableParagraphStyle()
        //将行间距设置为28
        paraph.lineSpacing = 4
        //样式属性集合
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12),
                          NSAttributedString.Key.paragraphStyle: paraph]
        if let contentString = content {
            self.descTextLabel.attributedText = NSAttributedString(string: contentString, attributes: attributes)
        }
//        self.descTextLabel.attributedText = NSAttributedString(string: "这是一段文本，这是一段文本，这是一段文本，这是一段文 本，这是一段文本，这是一段文本，这是一段文本，这是一 段文本。", attributes: attributes)
        
        for index in 0..<urlArray.count {
            
            let imgV = UIImageView()
            self.bgContentView.addSubview(imgV)
            imgV.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(index*210+index*2)
                make.left.right.equalToSuperview()
                make.height.equalTo(210)
            }
            
            imgV.kf.setImage(with: URL(string: urlArray[index]))

//            DispatchQueue.global().async {
//                if let imageURL = URL(string: imageUrl), let data = try? Data(contentsOf: imageURL) {
//                    let image = UIImage(data: data,scale: 1.0)
//                    DispatchQueue.main.async {
//                        imgV.image = image
//                    }
//                }
//            }
        }
		
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
}
