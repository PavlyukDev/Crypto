//
//  TickersManagerTests.swift
//  MyCryptoTests
//
//  Created by Vitaliy Pavlyuk on 05.06.2022.
//

import XCTest
import RxTest
import RxSwift

@testable import MyCrypto

class TickersManagerTests: XCTestCase {
    var tickersManager: TickersManager!
    var api: TickersApiMock!
    var bag: DisposeBag!
    override func setUpWithError() throws {
        api = TickersApiMock()
        tickersManager = TickersManagerImpl(api: api, pollingInterval: 1)
        bag = DisposeBag()
    }


    func testSendRequestAfterStartPolling() {
        // when
        tickersManager.startPolling()
        // then
        XCTAssertTrue(api.invokedGetTickers)
        XCTAssertEqual(api.invokedGetTickersCount, 1)
    }

    func testNotSendingRequestsUntilStart() {
        // then
        XCTAssertFalse(api.invokedGetTickers)
        XCTAssertEqual(api.invokedGetTickersCount, 0)
    }

    func testReceiveModels() {
        // Given
        let object: [TickerResponse] = JSONMapper.getObject(fromJson: "ValidTickersResponse")
        api.stubbedGetTickersResultCallbackResult = (object, ())
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Result<[TickerResponse], MyCryptoError>.self)
        tickersManager.tickersObservable.subscribe(observer).disposed(by: bag)
        // When
        tickersManager.startPolling()
        // Then
        XCTAssertEqual(observer.events,
                       Recorded.events(
                        .next(0, .success([])),
                        .next(0, .success(object))
                       )
        )
    }

    func testReceiveModelsAfterError() {
        // Given
        let error = MyCryptoError.unknown
        let object: [TickerResponse] = JSONMapper.getObject(fromJson: "ValidTickersResponse")
        api.stubbedGetTickersErrorCallbackResult = (error, ())
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Result<[TickerResponse], MyCryptoError>.self)
        tickersManager.tickersObservable.subscribe(observer).disposed(by: bag)
        // When
        tickersManager.startPolling()
        api.stubbedGetTickersResultCallbackResult = (object, ())
        api.stubbedGetTickersErrorCallbackResult = nil

        // Then
        let exp = expectation(description: "testReceiveModelsAfterError")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(observer.events,
                           Recorded.events(
                            .next(0, .success([])),
                            .next(0, .failure(error)),
                            .next(0, .success(object))
                           )
            )
        } else {
            XCTFail("testReceiveModelsAfterError failed")
        }
    }
}
