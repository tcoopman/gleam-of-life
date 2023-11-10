import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
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

pub fn fighting_no_neighbors_test() {
  fight(Rock, [])
  |> should.equal(Rock)
}

pub fn fight_one_neighbor_and_win_test() {
  fight(Rock, [Scissors])
  |> should.equal(Rock)
}

pub fn fight_multiple_neighbors_test() {
  fight(Rock, [Scissors, Rock, Paper])
  |> should.equal(Paper)
}

pub fn paper_fights_multiple_neighbors_test() {
  fight(Paper, [Scissors, Rock, Paper])
  |> should.equal(Scissors)
}

pub fn scissors_fights_multiple_neighbors_test() {
  fight(Scissors, [Scissors, Rock, Paper])
  |> should.equal(Rock)
}

pub fn fight_result_test() {
  apply_result(Rock, FightResult(0, 0, 0))
  |> should.equal(Rock)
}

pub fn fight_result_2_test() {
  apply_result(Rock, FightResult(0, 0, draws: 1))
  |> should.equal(Rock)
}

pub fn fight_result_3_test() {
  apply_result(Rock, FightResult(wins: 1, losses: 0, draws: 0))
  |> should.equal(Rock)
}

pub fn fight_result_4_test() {
  apply_result(Rock, FightResult(wins: 0, losses: 1, draws: 0))
  |> should.equal(Paper)
}

pub fn fight_result_5_test() {
  apply_result(Rock, FightResult(wins: 1, losses: 1, draws: 0))
  |> should.equal(Paper)
}

pub fn fight_result_6_test() {
  apply_result(Scissors, FightResult(1, losses: 1, draws: 0))
  |> should.equal(Rock)
}

pub fn general_test() {
  [
    #(Rock, [], Rock),
    #(Scissors, [], Scissors),
    #(Paper, [], Paper),
    #(Rock, [Paper], Paper),
    #(Rock, [Paper], Paper),
    #(Rock, [Paper, Paper, Scissors], Paper),
    #(Scissors, [Paper], Scissors),
  ]
  |> list.map(fn(test_params) {
    let #(cell, neighbors, expected) = test_params
    fight(cell, neighbors)
    |> should.equal(expected)
  })
}
