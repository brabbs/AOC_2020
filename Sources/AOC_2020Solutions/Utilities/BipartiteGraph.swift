//
//  BipartiteGraph.swift
//  
//
//  Created by Nicholas Brabbs on 16/12/2020.
//

import Foundation

struct BipartiteGraph<LeftVertex: Hashable, RightVertex: Hashable> {
    let left: Set<LeftVertex>
    let right: Set<RightVertex>
    typealias EdgeSet = Set<Edge<LeftVertex, RightVertex>>
    let edges: EdgeSet

    init<S: Sequence, T: Sequence>(
        left: S,
        right: T,
        isEdge: (LeftVertex, RightVertex) -> Bool
    ) where S.Element == LeftVertex, T.Element == RightVertex {
        self.left = Set(left)
        self.right = Set(right)

        var edges = EdgeSet()
        for leftVertex in self.left {
            for rightVertex in self.right {
                if isEdge(leftVertex, rightVertex) {
                    edges.insert(Edge(left: leftVertex, right: rightVertex))
                }
            }
        }
        self.edges = edges
    }

    func leftPerfectMatching() -> EdgeSet? {
        var matching = EdgeSet()
        while let unmatchedLeftVertex = getUnmatchedLeftVertex(from: matching) {
            guard let augmentingPath = getAugmentingPath(
                of: matching,
                from: unmatchedLeftVertex
            ) else {
                // No augmenting path means the graph doesn't satisfy Hall's
                return nil
            }
            // After augmenting we now match the unmatchedLeftVertex
            let newMatching = augment(matching: matching, with: augmentingPath)

            matching = newMatching
        }
        return matching
    }

    private func getUnmatchedLeftVertex(from matching: EdgeSet) -> LeftVertex? {
        left.first { vertex in
            matching.allSatisfy { edge in edge.left != vertex }
        }
    }

    private typealias AugmentingPathEdgePair = (
        matching: Edge<LeftVertex, RightVertex>,
        nonMatching: Edge<LeftVertex, RightVertex>
    )

    private func getAugmentingPath(of matching: EdgeSet, from start: LeftVertex) -> EdgeSet? {
        var w: Set<LeftVertex> = [start]
        var z: Set<RightVertex> = []

        var edgePairs = [AugmentingPathEdgePair]()

        while let edge = getEdge(from: w, to: right.subtracting(z)) {
            if let matchingEdge = getEdge(to: edge.right, in: matching) {
                w.insert(matchingEdge.left)
                z.insert(edge.right)

                let pair = (matching: matchingEdge, nonMatching: edge)
                edgePairs.append(pair)
            } else {
                // Right side of edge isn't in matching so we have an augmenting path
                return getAugmentingPath(from: edgePairs, startingAt: start, endingIn: edge)
            }
        }
        // Couldn't find edge so w doesn't satisfy Hall's
        return nil
    }

    private func getEdge(
        from leftSubset: Set<LeftVertex>,
        to rightSubset: Set<RightVertex>
    ) -> Edge<LeftVertex,RightVertex>? {
        let edge = edges.lazy
            .filter { edge in leftSubset.contains(edge.left) && rightSubset.contains(edge.right) }
            .first
        return edge
    }

    private func getEdge(
        to rightVertex: RightVertex,
        in edgeSet: EdgeSet
    ) -> Edge<LeftVertex,RightVertex>? {
        edgeSet.first { edge in edge.right == rightVertex }
    }

    /// Traverse back through the edge pairs picking out the ones we need for our path
    private func getAugmentingPath(
        from edgePairs: [AugmentingPathEdgePair],
        startingAt start: LeftVertex,
        endingIn end: Edge<LeftVertex, RightVertex>
    ) -> EdgeSet {
        var augmentingPath: EdgeSet = [end]
        var leftVertex = end.left

        for edgePair in edgePairs.reversed() {
            if leftVertex == start {
                break
            }

            if edgePair.matching.left == leftVertex {
                augmentingPath.insert(edgePair.matching)
                augmentingPath.insert(edgePair.nonMatching)
                leftVertex = edgePair.nonMatching.left
            }
        }

        return augmentingPath
    }

    private func augment(matching: EdgeSet, with augmentingPath: EdgeSet) -> EdgeSet {
        matching.symmetricDifference(augmentingPath)
    }
}

extension BipartiteGraph {
    struct Edge<LeftVertex: Hashable, RightVertex: Hashable>: Hashable {
        let left: LeftVertex
        let right: RightVertex
    }
}
