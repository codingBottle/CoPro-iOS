//
//  MyCommentsTableViewCell.swift
//  CoPro
//
//  Created by 박신영 on 2/2/24.
//

import UIKit
import SnapKit
import Then

class MyCommentsTableViewCell: UITableViewCell {
    
    //MARK: - UI Components

    private let contentLabel = UILabel().then {
       $0.setPretendardFont(text: "", size: 17, weight: .medium, letterSpacing: 1.22)
       $0.numberOfLines = 0
       $0.lineBreakMode = .byWordWrapping
    }
    
    private let commentTimeLabel = UILabel().then {
       $0.setPretendardFont(text: "", size: 13, weight: .regular, letterSpacing: 1)
       $0.textColor = UIColor.G4()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubviews(contentLabel, commentTimeLabel)
        
       // 댓글이 길어졌을 때도 괜찮으려면 높이설정하지 않는 것과, 좌우설정하여 넓이를 알 수 있도록 해야한다.
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(16)
           $0.trailing.equalToSuperview().offset(-16)
        }
        
        commentTimeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-10)
           $0.height.equalTo(16)
           $0.top.equalTo(contentLabel.snp.bottom).offset(10)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCellWriteCommentbyMe(_ data: MyWrittenCommentDataModel) {
        contentLabel.text = data.content
        commentTimeLabel.text = data.getMyWrittenCommentDateString()
    }
}

