import gleam/bool
import gleam/list

import types.{type Cell, type Position, type Universe, Alive, Dead}

// module GameOfLife exposing (evolve, findCell)

// import Rules exposing (applyRules)
// import Types exposing (..)
// import Set exposing (..)

// isNeighbour : Position -> Position -> Bool
// isNeighbour ( x1, y1 ) ( x2, y2 ) =
//     (abs (x1 - x2) <= 1)
//         && (abs (y1 - y2) <= 1)
//         && (( x1, y1 ) /= ( x2, y2 ))

// findNeighbours : Universe -> Position -> Neighbours
// findNeighbours universe position =
//     universe
//         |> List.filter (isNeighbour position << Tuple.first)
//         |> List.map Tuple.second

// evolveCell : Universe -> PositionedCell -> PositionedCell
// evolveCell universe ( position, cell ) =
//     let
//         neighbours =
//             findNeighbours universe position

//         evolvedCell =
//             applyRules cell neighbours
//     in
//         ( position, evolvedCell )

fn has_alive_cell(universe: Universe, position: Position) -> Bool {
  let in_bounds = fn(cell: Cell) {
    let #(cell_position, _) = cell
    cell_position == position
  }
  universe
  |> list.filter(in_bounds)
  |> list.is_empty
  |> bool.negate
}

pub fn find_cell(universe: Universe, position: Position) -> Cell {
  case has_alive_cell(universe, position) {
    True -> #(position, Alive)
    False -> #(position, Dead)
  }
}
// dedupe : Universe -> Universe
// dedupe universe =
//     let
//         positions =
//             List.map Tuple.first universe

//         dedupedPositions =
//             positions
//                 |> Set.fromList
//                 |> Set.toList
//     in
//         List.map (findCell universe) dedupedPositions

// evolve : Universe -> Universe
// evolve universe =
//     let
//         otherPositions ( x, y ) =
//             [ ( x - 1, y - 1 )
//             , ( x, y - 1 )
//             , ( x + 1, y - 1 )
//             , ( x - 1, y )
//             , ( x + 1, y )
//             , ( x - 1, y + 1 )
//             , ( x, y + 1 )
//             , ( x + 1, y + 1 )
//             ]

//         cells position =
//             List.map (findCell universe) (otherPositions position)

//         currentUniverse =
//             universe
//                 |> List.map Tuple.first
//                 |> List.map cells
//                 |> List.concat
//                 |> dedupe
//     in
//         currentUniverse
//             |> List.map (evolveCell universe)
//             |> List.filter ((==) Alive << Tuple.second)
