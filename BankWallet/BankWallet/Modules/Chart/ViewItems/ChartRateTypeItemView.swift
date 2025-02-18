import UIKit
import UIExtensions
import ActionSheet
import SnapKit

class ChartRateTypeItemView: BaseActionItemView {
    private var buttons = [RespondButton]()

    private let dateLabel = UILabel()
    private let valueLabel = UILabel()

    override var item: ChartRateTypeItem? { return _item as? ChartRateTypeItem }

    override func initView() {
        super.initView()

        addSubview(dateLabel)
        dateLabel.font = ChartRateTheme.chartRateDateFont
        dateLabel.textColor = ChartRateTheme.chartRateDateColor
        addSubview(valueLabel)
        valueLabel.font = ChartRateTheme.chartRateValueFont
        valueLabel.textColor = ChartRateTheme.chartRateValueColor
        valueLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(ChartRateTheme.chartRateValueTopMargin)
            maker.centerX.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { maker in
            maker.top.equalTo(valueLabel.snp.bottom).offset(ChartRateTheme.chartRateDateTopMargin)
            maker.centerX.equalToSuperview()
        }


        item?.bindButton = { [weak self] (title, tag, action) in
            self?.addButton(title: title, tag: tag, action: action)
        }
        item?.setSelected = { [weak self] tag in
            self?.setSelected(tag: tag)
        }
        item?.setEnabled = { [weak self] tag in
            self?.setEnabled(tag: tag)
        }
        item?.showPoint = { [weak self] date, value in
            self?.showPoint(date: date, value: value)
        }
    }

    private func showPoint(date: String?, value: String?) {
        dateLabel.text = date
        valueLabel.text = value
        showButtons(date == nil || value == nil)
    }

    private func showButtons(_ show: Bool) {
        dateLabel.isHidden = show
        valueLabel.isHidden = show
        buttons.forEach { $0.isHidden = !show }
    }

    private func setSelected(tag: Int) {
        buttons.forEach { button in
            let nonSelectedState: RespondButton.State = button.state == .disabled ? .disabled : .active
            button.state = button.tag == tag ? .selected : nonSelectedState
        }
    }

    public func setEnabled(tag: Int) {
        buttons.forEach { button in
            if button.tag == tag {
                button.state = button.state == .selected ? .selected : .active
            }
        }
    }

    private func addButton(title: String, tag: Int, action: (() -> ())?) {
        let toggleAction = { [weak self] in
            self?.setSelected(tag: tag)
            action?()
        }
        let button = RespondButton(onTap: toggleAction)
        button.changeBackground = false
        button.tag = tag
        button.state = .disabled
        button.textColors = [.active: ChartRateTheme.buttonTextColor, .selected: ChartRateTheme.buttonSelectedTextColor, .disabled: ChartRateTheme.buttonDisabledTextColor]
        button.titleLabel.text = title.localized
        button.titleLabel.font = ChartRateTheme.buttonFont
        button.titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.wrapperView.snp.remakeConstraints { maker in
            maker.leading.equalToSuperview().offset(ChartRateTheme.buttonMargin)
            maker.top.bottom.equalToSuperview()
            maker.trailing.equalToSuperview().offset(-ChartRateTheme.buttonMargin)
        }

        addSubview(button)
        buttons.append(button)

        updateButtonConstraints()
    }

    private func updateButtonConstraints() {
        guard buttons.count != 0 else {
            return
        }

        var lastButton: UIView = buttons[0]
        lastButton.snp.remakeConstraints { maker in
            maker.left.equalToSuperview().offset(ChartRateTheme.margin)
            maker.top.equalToSuperview().offset(ChartRateTheme.buttonMargin)
            maker.height.equalTo(ChartRateTheme.buttonHeight)
            if buttons.count == 1 { // just one button
                maker.width.equalTo(ChartRateTheme.buttonDefaultWidth)
            }
        }
        for i in 1..<buttons.count {
            buttons[i].snp.remakeConstraints { maker in
                maker.left.equalTo(lastButton.snp.right).offset(ChartRateTheme.buttonMargin)
                maker.top.equalToSuperview().offset(ChartRateTheme.buttonMargin)
                maker.height.equalTo(ChartRateTheme.buttonHeight)
                maker.width.equalTo(lastButton.snp.width)
                if buttons.count == i + 1 { // last button right constraint
                    maker.right.equalToSuperview().offset(-ChartRateTheme.margin)
                }
            }
            lastButton = buttons[i]
        }
    }

}
