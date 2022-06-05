//
//  ListViewModelTests.swift
//  MyCryptoTests
//
//  Created by Vitaliy Pavlyuk on 05.06.2022.
//

import XCTest
import RxTest
import RxSwift

@testable import MyCrypto

class ListViewModelTests: XCTestCase {
    var manager: TickersManagerMock!
    var viewModel: ListViewModel!
    var bag: DisposeBag!

    override func setUpWithError() throws {
        manager = TickersManagerMock()
        viewModel = ListViewModel(manager: manager)
        bag = DisposeBag()
    }

    func testPollingStartsAfterStarting() {
        // when
        viewModel.start()
        // then
        XCTAssertTrue(manager.invokedStartPolling)
        XCTAssertEqual(manager.invokedStartPollingCount, 1)
    }

    func testUpdateTickers() {
        // given
        let objects: [TickerResponse] = JSONMapper.getObject(fromJson: "ValidTickersResponse")
        manager.stubbedTickersObservableSubject.on(.next(.success(objects)))
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([TickerModel].self)
        viewModel.tickers.drive(observer).disposed(by: bag)

        // when
        viewModel.start()
        // then
        XCTAssertEqual(observer.events.count, 2)
    }

    func testParcingTickers() {
        // given
        let objects: [TickerResponse] = JSONMapper.getObject(fromJson: "ValidTickersResponse")
        let models = [TickerModel(ticker: Ticker(rawValue: "tBTCUSD")!, price: "29,696 $")]

        manager.stubbedTickersObservableSubject.on(.next(.success(objects)))
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([TickerModel].self)
        viewModel.tickers.drive(observer).disposed(by: bag)

        // when
        viewModel.start()
        // then
        XCTAssertEqual(observer.events, Recorded.events(
            .next(0, []),
            .next(0, models)
        ))

    }

    func testSearch() {
        // given
        let objects: [TickerResponse] = JSONMapper.getObject(fromJson: "MultipleTickersResponse")
        let models = [
            TickerModel(ticker: Ticker(rawValue: "tBTCUSD")!, price: "29,762 $"),
            TickerModel(ticker: Ticker(rawValue: "tETHUSD")!, price: "1,792.4 $"),
            TickerModel(ticker: Ticker(rawValue: "tLTCUSD")!, price: "62.822 $")
        ]

        manager.stubbedTickersObservableSubject.on(.next(.success(objects)))

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver([TickerModel].self)
        viewModel.tickers.drive(observer).disposed(by: bag)
        // when
        viewModel.start()
        viewModel.searchSubject.accept("BTC")

        // then
        XCTAssertEqual(observer.events.count, 3)
        XCTAssertEqual(observer.events, Recorded.events(
            .next(0, []),
            .next(0, models),
            .next(0, [models[0]])
        ))
    }
}

