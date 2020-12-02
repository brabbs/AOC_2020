import ArgumentParser
import AOC_2020Solutions

struct PrintSolution: ParsableCommand {
    @Option(name: .shortAndLong, help: "The day of Advent of Code")
    var week: Int

    func run() {
        do {
            let solution = try getSolution(week)
            print(solution.first())
            print(solution.second())
        } catch {
            print(error)
        }
    }
}

PrintSolution.main()
