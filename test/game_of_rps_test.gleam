import gleam/int
import gleam/result
import gleam/io
import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub type LocationState {
  Alive(cell: Cell)
  Dead
}

pub type Cell {
  Rock
  Paper
  Scissors
}

pub type Battle {
  Win
  Loss
  Draw
}

fn battle(cell, other) {
  case #(cell, other) {
    #(Rock, Scissors) -> Win
    #(Rock, Paper) -> Loss
    #(Rock, Rock) -> Draw
    #(Paper, Scissors) -> Loss
    #(Paper, Rock) -> Win
    #(Paper, Paper) -> Draw
    #(Scissors, Scissors) -> Draw
    #(Scissors, Rock) -> Loss
    #(Scissors, Paper) -> Win
  }
}

fn fight_(cell, neighbors, result: FightResult) {
  case neighbors {
    [] -> result
    [neighbor, ..neighbors] -> {
      let new_result = case battle(cell, neighbor) {
        Win -> FightResult(result.wins + 1, result.losses, result.draws)
        Loss -> FightResult(result.wins, result.losses + 1, result.draws)
        Draw -> FightResult(result.wins, result.losses, result.draws + 1)
      }
      fight_(cell, neighbors, new_result)
    }
  }
}

pub fn fight(cell: Cell, neighbors: List(Cell)) {
  let result =
    fight_(cell, neighbors, FightResult(wins: 0, losses: 0, draws: 0))
  apply_result(cell, result)
}

fn apply_result(cell, result: FightResult) {
  case result.losses >= result.wins && result.losses > 0 {
    True ->
      case cell {
        Rock -> Paper
        Paper -> Scissors
        Scissors -> Rock
      }
    False -> cell
  }
}

pub type FightResult {
  FightResult(wins: Int, losses: Int, draws: Int)
}

pub fn general_test() {
  [
    #(Rock, [], Rock),
    #(Scissors, [], Scissors),
    #(Paper, [], Paper),
    #(Rock, [Paper], Paper),
    #(Rock, [Paper, Rock], Paper),
    #(Rock, [Paper, Scissors], Paper),
    #(Rock, [Paper, Scissors, Scissors], Rock),
    #(Rock, [Paper, Rock, Rock], Paper),
    #(Rock, [Paper, Paper, Scissors], Paper),
    #(Scissors, [Paper], Scissors),
  ]
  |> list.map(fn(test_params) {
    let #(cell, neighbors, expected) = test_params
    fight(cell, neighbors)
    |> should.equal(expected)
  })
}

pub fn is_neighbor(position, other) {
  let Position(x: x, y: y) = position
  let Position(x: x_neighbor, y: y_neighbor) = other
  let x_delta =
    x - x_neighbor
    |> int.absolute_value
  let y_delta =
    y - y_neighbor
    |> int.absolute_value
  case #(x_delta, y_delta) {
    #(1, 1) -> True
    #(0, 1) -> True
    #(1, 0) -> True
    _ -> False
  }
}

pub fn find_neighbors(location: #(Position, LocationState), world) {
  let #(position, _) = location
  list.filter(
    world,
    fn(x) {
      let #(neighbor_position, cell_state) = x
      case cell_state {
        Dead -> False
        Alive(_) -> is_neighbor(position, neighbor_position)
      }
    },
  )
}

pub fn apply_rule(pos: #(Position, LocationState), neighbors) {
  let #(position, location_state) = pos
  let nb_of_neighbors = list.length(neighbors)
  case #(location_state, nb_of_neighbors) {
    #(Alive(cell), 2) | #(Alive(cell), 3) -> {
      let neighbors =
        list.filter_map(
          neighbors,
          fn(n) {
            let #(_, location_state) = n
            case location_state {
              Alive(c) -> Ok(c)
              Dead -> Error(Nil)
            }
          },
        )
      let transformed_cell = fight(cell, neighbors)
      Ok(#(position, Alive(transformed_cell)))
    }
    _ -> Error(Nil)
  }
}

pub fn find_cradles(world) {
  list.flat_map(
    world,
    fn(position_with_cell) {
      let #(Position(x: x, y: y), _) = position_with_cell
      [
        Position(x - 1, y - 1),
        Position(x, y - 1),
        Position(x + 1, y - 1),
        Position(x - 1, y),
        Position(x, y),
        Position(x + 1, y),
        Position(x - 1, y + 1),
        Position(x, y + 1),
        Position(x + 1, y + 1),
      ]
    },
  )
  |> list.unique
  |> list.map(fn(pos) {
    let alive =
      list.find_map(
        world,
        fn(position_with_cell) {
          let #(Position(x: x, y: y), cell) = position_with_cell
          let Position(x: x_, y: y_) = pos
          case x == x_ && y == y_ {
            True -> Ok(cell)
            False -> Error(Nil)
          }
        },
      )
    case alive {
      Ok(cell) -> #(pos, cell)
      Error(_) -> #(pos, Dead)
    }
  })
}

fn world_to_internal(world) {
  world
  |> list.map(fn(location) {
    let Location(x: x, y: y, cell: cell) = location
    #(Position(x, y), Alive(cell))
  })
}

fn internal_to_world(world) {
  world
  |> list.filter_map(fn(x: #(Position, LocationState)) {
    let #(position, location_state) = x
    case location_state {
      Dead -> Error(Nil)
      Alive(cell) -> Ok(Location(position.x, position.y, cell))
    }
  })
}

pub fn evolve(world) {
  let world = world_to_internal(world)

  let evolved_world =
    world
    |> find_cradles()
    |> list.filter_map(fn(position_with_cell) {
      let neighbors = find_neighbors(position_with_cell, world)
      apply_rule(position_with_cell, neighbors)
    })

  internal_to_world(evolved_world)
}

pub type Position {
  Position(x: Int, y: Int)
}

pub type Location {
  Location(x: Int, y: Int, cell: Cell)
}

pub fn gol_test() {
  [
    #([], []),
    #([Location(x: 0, y: 0, cell: Rock)], []),
    #(
      [
        Location(x: 0, y: 0, cell: Rock),
        Location(x: 1, y: 0, cell: Rock),
        Location(x: 2, y: 0, cell: Rock),
      ],
      [Location(x: 1, y: 0, cell: Rock)],
    ),
    #(
      [
        Location(x: 0, y: 0, cell: Paper),
        Location(x: 1, y: 0, cell: Rock),
        Location(x: 2, y: 0, cell: Paper),
      ],
      [Location(x: 1, y: 0, cell: Paper)],
    ),
  ]
  |> list.map(fn(test_params) {
    let #(world, evolved_world) = test_params
    evolve(world)
    |> should.equal(evolved_world)
  })
}
