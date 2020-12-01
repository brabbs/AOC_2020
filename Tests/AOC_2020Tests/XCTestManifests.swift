import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AOC_2020Tests.allTests),
    ]
}
#endif
