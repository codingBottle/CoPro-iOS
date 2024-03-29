//
//  recentSearchTableViewCell.swift
//  CoPro
//
//  Created by 문인호 on 1/3/24.
//

import UIKit

import SnapKit
import Then

protocol RecentSearchTableViewCellDelegate: AnyObject {
    func recentSearchTableViewCellDidRequestDelete(_ cell: recentSearchTableViewCell)
}

class recentSearchTableViewCell: UITableViewCell {
    
    //MARK: - UI Components

    static let id = "recentSearchTableViewCell"
    private let circleView = UIView()
    private let clockImageView = UIImageView()
    private let searchLabel = UILabel()
    let deleteButton = UIButton()
    weak var delegate: RecentSearchTableViewCellDelegate?

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI Components Property
    
    private func setStyle() {
        separatorInset.left = 0
        selectionStyle = .none
        circleView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 24 / 2
            $0.layer.borderColor = UIColor.G3().cgColor
            $0.layer.borderWidth = 0.2
        }
        clockImageView.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.image = UIImage(systemName: "clock")
            $0.tintColor = UIColor.G4()
        }
        searchLabel.do {
            $0.font = .pretendard(size: 13, weight: .regular)
            $0.textColor = .black
        }
        deleteButton.do {
            $0.setImage(UIImage(systemName: "xmark"), for: .normal)
            $0.tintColor = UIColor.G4()
            $0.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        }
    }
    private func setLayout() {
        addSubviews(circleView, searchLabel, deleteButton)
        circleView.addSubview(clockImageView)
        
        circleView.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        clockImageView.snp.makeConstraints {
            $0.height.width.equalTo(12)
            $0.centerX.equalTo(circleView.snp.centerX)
            $0.centerY.equalTo(circleView.snp.centerY)
        }
        searchLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
            $0.left.equalTo(circleView.snp.right).offset(10)
            $0.width.equalTo(300)
            $0.height.equalTo(25)
        }
        deleteButton.snp.makeConstraints {
            $0.height.width.equalTo(12)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    func configureCell(_ data: BoardDataModel) {
        searchLabel.text = data.title
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func prepareForReuse() {
      super.prepareForReuse()
      self.prepare(text: nil)
    }

    func prepare(text: String?) {
        self.searchLabel.text = text
    }
    
    public func getSearchLabelText() -> String? {
            return searchLabel.text
        }
    
    @objc private func didTapDeleteButton() {
            delegate?.recentSearchTableViewCellDidRequestDelete(self)
        }
}

