//
//  TCalendarCell.swift
//  DesignSystem
//
//  Created by 박민서 on 2/1/25.
//  Copyright © 2025 yapp25thTeamTnT. All rights reserved.
//

import FSCalendar

/// TCalendar에 사용되는 Cell 입니다
final class TCalendarCell: FSCalendarCell {
    // MARK: Properties
    static let identifier: String = "TCalendarCell"
    
    /// Cell에 표시되는 날짜
    private var customDate: Date?
    /// Cell 이 선택되었는지 표시
    private var isCellSelected: Bool = false
    /// Cell 스타일
    private var style: Style = .default
    /// Cell에 표시되는 일정 카운트
    private var eventCount: Int = 0
    /// 주간/월간/컴팩트 모드인지 표시
    private var mode: TCalendarType = .month

    // MARK: UI Elements
    private let dayLabel: UILabel = UILabel()
    private let eventStackView: UIStackView = UIStackView()
    private let eventIcon: UIImageView = UIImageView()
    private let eventCountLabel: UILabel = UILabel()
    private let backgroundContainer: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setUpHierarchy()
        setUpConstraint()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundContainer.layer.cornerRadius = 8
        
        dayLabel.font = Typography.FontStyle.body2Medium.uiFont
        dayLabel.textAlignment = .center
        
        eventStackView.axis = .horizontal
        eventStackView.spacing = 2
        eventStackView.alignment = .center
        
        eventIcon.image = UIImage(resource: .icnStar).withRenderingMode(.alwaysTemplate)
        eventIcon.tintColor = UIColor(.red300)
        eventIcon.contentMode = .scaleAspectFit
        eventIcon.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        
        eventCountLabel.font = Typography.FontStyle.label2Medium.uiFont
        eventCountLabel.textColor = UIColor(.neutral400)
    }
    
    private func setUpHierarchy() {
        eventStackView.addArrangedSubview(eventIcon)
        eventStackView.addArrangedSubview(eventCountLabel)
        
        contentView.addSubview(backgroundContainer)
        contentView.addSubview(dayLabel)
        contentView.addSubview(eventStackView)
    }
    
    private func setUpConstraint() {
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
    
    /// 셀 스타일 표시 업데이트
    private func updateAppearance() {
        dayLabel.textColor = style.textColor
        backgroundContainer.backgroundColor = style.backgroundColor
    }
    
    /// 일정 카운트 표시 업데이트
    private func updateEventDisplay() {
        guard mode != .compactMonth else {
            eventStackView.isHidden = true
            return
        }
        eventCountLabel.text = "\(eventCount)"
        let eventExists: Bool = eventCount > 0
        eventStackView.isHidden = !eventExists
        let presentCount: Bool = mode == .month && eventExists
        eventCountLabel.isHidden = !presentCount
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 날짜 및 선택 상태 초기화
        customDate = nil
        isCellSelected = false
        mode = .month
        
        // 일정 관련 초기화
        eventCount = 0
        eventStackView.isHidden = true
        eventCountLabel.text = nil
        
        // 스타일 초기화
        style = .default
        updateAppearance()
        updateEventDisplay()
    }
}

extension TCalendarCell {
    /// 셀 설정
    func configure(
        with date: Date,
        isCellSelected: Bool,
        eventCount: Int = 0,
        mode: TCalendarType = .month
    ) {
        self.customDate = date
        self.isCellSelected = isCellSelected
        self.eventCount = eventCount
        self.mode = mode
        
        // 현재 날짜 및 선택 상태를 반영, Style 설정
        if isCellSelected {
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
}

extension TCalendarCell {
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
