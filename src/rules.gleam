import gleam/list

import types.{Alive, Dead}

type LifeCycle {
  Dies
  Revives
  Same
}

fn number_of_live(neighbours) {
  neighbours
  |> list.filter(fn(status) { status == Alive })
  |> list.length
}

fn under_population_rule(cell, neighbours) {
  case cell {
    Alive ->
      case number_of_live(neighbours) {
        n if n < 2 -> Dies
        _ -> Same
      }
    Dead -> Same
  }
}

fn lives_on_rule(cell, neighbours) {
  case cell {
    Alive ->
      case number_of_live(neighbours) {
        n if n == 2 || n == 3 -> Same
        _ -> Dies
      }
    Dead -> Same
  }
}

fn over_population_rule(cell, neighbours) {
  case cell {
    Alive ->
      case number_of_live(neighbours) {
        n if n > 3 -> Dies
        _ -> Same
      }
    Dead -> Same
  }
}

fn reproduction_rule(cell, neighbours) {
  case cell {
    Alive -> Same
    Dead ->
      case number_of_live(neighbours) {
        n if n == 3 -> Revives
        _ -> Same
      }
  }
}

fn reduce_lifecycle(cell, neighbours) {
  let actions =
    [
      under_population_rule,
      lives_on_rule,
      over_population_rule,
      reproduction_rule,
    ]
    |> list.map(fn(rule) { rule(cell, neighbours) })
    |> list.filter(fn(action) { action != Same })

  case actions {
    [] -> Same
    [head, ..] -> head
  }
}

pub fn apply_rules(cell, neighbours) {
  let action = reduce_lifecycle(cell, neighbours)
  case action {
    Dies -> Dead
    Revives -> Alive
    Same -> cell
  }
}
