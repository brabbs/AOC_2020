import ArgumentParser
import AOC_2020Solutions

struct PrintSolution: ParsableCommand {
    @Option(name: .shortAndLong, help: "The day of Advent of Code")
    var day: Int

    func run() {
        do {
            let solution = try getSolution(day)
            print(try solution.first())
            print(try solution.second())
        } catch {
            print(error)
        }
    }
}

PrintSolution.main()
