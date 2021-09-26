//
//  ViewController.swift
//  Calender-Sample
//
//  Created by Yus Inoue on 2021/09/26.
//

import UIKit


struct Month {
    var date: Date
    var days: [Int?]
}

class ViewController: UIViewController {
    
    private lazy var months = makeMonth(from: Date())
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = .init(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    private lazy var calendarView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .yellow
//        view.layer.masksToBounds = false
//        view.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        view.layer.shadowOpacity = 0.25
//        view.layer.shadowOffset = .init(width: 0, height: 4)
//        view.layer.shadowRadius = 4
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    private lazy var yearMonthLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "2021年 9月"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "RightArrow"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "LeftArrow"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var weekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let dayOfWeek = ["日", "月", "火", "水", "木", "金", "土"]
        for string in dayOfWeek {
            let label: UILabel = {
                let _label = UILabel()
                _label.text = string
                _label.font = .systemFont(ofSize: 14)
                _label.textAlignment = .center
                _label.baselineAdjustment = .alignCenters
                _label.backgroundColor = .white
                _label.textColor = .black
                return _label
            }()
            stackView.addArrangedSubview(label)
        }
        return stackView
    }()
    
    private lazy var calendarView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)

        let numberOfColumns: CGFloat = 7
        let itemWidth = view.frame.width / numberOfColumns
        layout.itemSize = .init(width: itemWidth, height: itemWidth)

        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        
        calendarView.dataSource = self
        calendarView.delegate = self
        
        calendarView.backgroundColor = .yellow
        calendarView.allowsMultipleSelection = false
        calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.id)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.layoutIfNeeded()

        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.addSubview(backButton)
        headerView.addSubview(yearMonthLabel)
        headerView.addSubview(forwardButton)

        view.addSubview(weekStackView)
        view.addSubview(headerView)
        view.addSubview(calendarView)
        
        adjustLayout()
    }
    
    private func adjustLayout() {
        forwardButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        forwardButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20).isActive = true
        forwardButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        forwardButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        yearMonthLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        yearMonthLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        
        backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        backButton.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        weekStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        weekStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        weekStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        weekStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        calendarView.topAnchor.constraint(equalTo: weekStackView.bottomAnchor).isActive = true
        calendarView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        calendarView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func makeMonth(from date: Date) -> Month? {
        let calender = Calendar(identifier: .gregorian)
        
        let year  = calender.dateComponents(in: .current, from: date).year
        let month = calender.dateComponents(in: .current, from: date).month
        let dateComponents = DateComponents(year: year, month: month, day: 1)
        
        guard let endMonthdate = calender.date(from: dateComponents),
              let dayRange = calender.range(of: .day, in: .month, for: endMonthdate) else {
            return nil
        }

        let firstWeekdayInMonth = calender.component(.weekday, from: endMonthdate)
        
        guard let indexOfFirstWeekday = [1,2,3,4,5,6,7].firstIndex(of: firstWeekdayInMonth) else {
            return nil
        }
        
        let days = (1 - indexOfFirstWeekday..<dayRange.endIndex).map { $0 > 0 ? $0 : nil }
        
        return Month(date: endMonthdate, days: days)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months?.days.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.id, for: indexPath) as! CalendarCell
        let day = months?.days[indexPath.item]
        cell.setDay(day)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout { }

// MARK: - Cell
final class CalendarCell: UICollectionViewCell {
    
    static let id = String(describing: CalendarCell.self)
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        label.lineBreakMode = .byClipping
        label.font = .systemFont(ofSize: 16)
        label.backgroundColor = .clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dayLabel)

        dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDay(_ day: Int?) {
        dayLabel.text = day != nil ? "\(day!)" : ""
    }
}

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
