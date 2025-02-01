//
//  CustumCalendarCell.swift
//  DesignSystem
//
//  Created by 박민서 on 2/1/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import FSCalendar

class FSCustomCalendarCell: FSCalendarCell {
    
    static let identifier: String = "CustomCalendarCell"
    static let cellSize: CGSize = CGSize(width: 51, height: 54)
    
    var customDate: Date?
    var isCustomSelected: Bool = false
    var style: Style = .default
    var eventCount: Int = 0
    var isWeekMode: Bool = false

    private let dayLabel = UILabel()
    private let eventStackView = UIStackView()
    private let eventIcon = UIImageView()
    private let eventCountLabel = UILabel()
    private let backgroundContainer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(backgroundContainer)
        backgroundContainer.layer.cornerRadius = 8
        
        // 📌 날짜 라벨 설정
        dayLabel.font = Typography.FontStyle.body2Medium.uiFont
        dayLabel.textAlignment = .center
        
        // 📌 이벤트 스택뷰 설정
        eventStackView.axis = .horizontal
        eventStackView.spacing = 2
        eventStackView.alignment = .center
        
        // 📌 이벤트 아이콘 설정
        eventIcon.image = UIImage(resource: .icnStar).withRenderingMode(.alwaysTemplate)
        eventIcon.tintColor = UIColor(.red300)
        eventIcon.contentMode = .scaleAspectFit
        eventIcon.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        
        // 📌 이벤트 카운트 라벨 설정
        eventCountLabel.font = Typography.FontStyle.label2Medium.uiFont
        eventCountLabel.textColor = UIColor(.neutral400)

        eventStackView.addArrangedSubview(eventIcon)
        eventStackView.addArrangedSubview(eventCountLabel)
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(eventStackView)

        // 📌 오토레이아웃 설정
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        eventStackView.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            dayLabel.widthAnchor.constraint(equalToConstant: 32),
            dayLabel.heightAnchor.constraint(equalToConstant: 32),

            backgroundContainer.centerXAnchor.constraint(equalTo: dayLabel.centerXAnchor),
            backgroundContainer.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            backgroundContainer.widthAnchor.constraint(equalTo: dayLabel.widthAnchor),
            backgroundContainer.heightAnchor.constraint(equalTo: dayLabel.heightAnchor),
            
            eventStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            eventStackView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 4)
        ])
    }
    
    /// 📌 스타일 및 이벤트 표시 업데이트
    private func updateAppearance() {
        dayLabel.textColor = style.textColor
        backgroundContainer.backgroundColor = style.backgroundColor
    }
    
    private func updateEventDisplay() {
        eventCountLabel.text = "\(eventCount)"
        let eventExists: Bool = eventCount > 0
        eventStackView.isHidden = !eventExists
        let presentCount = !isWeekMode && eventExists
        eventCountLabel.isHidden = !presentCount
    }
    
    /// 📌 날짜 설정
    func configure(
        with date: Date,
        isSelected: Bool,
        eventCount: Int = 0,
        isWeekMode: Bool = false
    ) {
        self.customDate = date
        self.isCustomSelected = isSelected
        self.eventCount = eventCount
        self.isWeekMode = isWeekMode
        
        // 🔹 현재 날짜 및 선택 상태를 반영하여 동적으로 Style 설정
        if isSelected {
            self.style = .selected
        } else if Calendar.current.isDateInToday(date) {
            self.style = .today
        } else {
            self.style = .default
        }
        
        dayLabel.text = "\(Calendar.current.component(.day, from: date))"
        self.updateAppearance()
        self.updateEventDisplay()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // ✅ 날짜 및 선택 상태 초기화
        customDate = nil
        isCustomSelected = false
        isWeekMode = false
        
        // ✅ 이벤트 관련 초기화
        eventCount = 0
        eventStackView.isHidden = true
        eventCountLabel.text = nil
        
        // ✅ 스타일 초기화
        style = .default
        updateAppearance()
        updateEventDisplay()
    }
    
}

// MARK: - 스타일 설정
extension FSCustomCalendarCell {
    enum Style {
        case `default`
        case today
        case selected
        
        var textColor: UIColor {
            switch self {
            case .default, .today:
                return UIColor(.neutral600)
            case .selected:
                return UIColor(.common0)
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .default:
                return .clear
            case .today:
                return UIColor(.neutral200)
            case .selected:
                return UIColor(.neutral900)
            }
        }
    }
}
