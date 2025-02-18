import Foundation

class RateListPresenter {
    weak var view: IRateListView?

    private let interactor: IRateListInteractor
    private let router: IRateListRouter
    private var dataSource: IRateListItemDataSource

    init(interactor: IRateListInteractor, router: IRateListRouter, dataSource: IRateListItemDataSource) {
        self.interactor = interactor
        self.router = router
        self.dataSource = dataSource
    }

}

extension RateListPresenter: IRateListViewDelegate {

    func viewDidLoad() {
        dataSource.set(coins: interactor.coins)

        let coinCodes = dataSource.coinCodes

        interactor.fetchRates(currencyCode: interactor.currency.code, coinCodes: coinCodes)
        interactor.getRateStats(currencyCode: interactor.currency.code, coinCodes: coinCodes)

        view?.reload()
    }

    var currentDate: Date {
        return interactor.currentDate
    }

    var itemCount: Int {
        return dataSource.items.count
    }

    func item(at index: Int) -> RateViewItem {
        return dataSource.items[index]
    }

}

extension RateListPresenter: IRateListInteractorDelegate {

    func didBecomeActive() {
        interactor.getRateStats(currencyCode: interactor.currency.code, coinCodes: dataSource.coinCodes)
    }

    func didUpdate(rate: Rate) {
        dataSource.set(rate: rate, with: interactor.currency)
        view?.reload()
    }

    func didReceive(chartData: ChartData) {
        dataSource.set(chartData: chartData)
        view?.reload()
    }

    func didFailStats(for coinCode: CoinCode) {
        dataSource.setStatsFailed(coinCode: coinCode)
        view?.reload()
    }

}
