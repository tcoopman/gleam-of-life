import gleam/int
import gleam/list
import gleam/option.{type Option}
import gleam/pair
import gleam/set

import rules
import types.{
  type Cell, type Neighbours, type Position, type Universe, Alive, Dead,
}

fn find_neighbours(universe: Universe, position: Position) -> Neighbours {
  let is_neighbour = fn(pos_1, pos_2) {
    let #(x1, y1) = pos_1
    let #(x2, y2) = pos_2
    int.absolute_value(x1 - x2) <= 1
    && int.absolute_value(y1 - y2) <= 1
    && pos_1 != pos_2
  }
  universe
  |> list.filter(fn(cell) { is_neighbour(position, pair.first(cell)) })
  |> list.map(pair.second)
}

fn evolve_cell(universe: Universe, cell: Cell) -> Cell {
  let #(position, status) = cell
  let neighbours = find_neighbours(universe, position)
  #(position, rules.apply_rules(status, neighbours))
}

fn find_maybe_cell(universe: Universe, position: Position) -> Option(Cell) {
  let in_bounds = fn(cell: Cell) {
    let #(cell_position, _) = cell

    cell_position == position
  }
  case universe |> list.filter(in_bounds) {
    [] -> option.None
    [c, ..] -> {
      option.Some(c)
    }
  }
}

pub fn find_cell(universe: Universe, position: Position) -> Cell {
  case find_maybe_cell(universe, position) {
    option.Some(cell) -> cell
    option.None -> #(position, Dead)
  }
}

pub fn dedupe(universe: Universe) -> Universe {
  let positions = list.map(universe, pair.first)
  let deduped =
    positions
    |> set.from_list
    |> set.to_list
  list.map(deduped, find_cell(universe, _))
}

pub fn evolve(universe: Universe) -> Universe {
  let other_positions = fn(position) {
    let #(x, y) = position
    [
      #(x - 1, y - 1),
      #(x, y - 1),
      #(x + 1, y - 1),
      #(x - 1, y),
      #(x + 1, y),
      #(x - 1, y + 1),
      #(x, y + 1),
      #(x + 1, y + 1),
    ]
  }

  let cells = fn(position) {
    list.map(other_positions(position), find_cell(universe, _))
  }

  let current_universe =
    universe
    |> list.map(pair.first)
    |> list.map(cells)
    |> list.concat
    |> dedupe

  current_universe
  |> list.map(evolve_cell(universe, _))
  |> list.filter(fn(cell) { pair.second(cell) == Alive })
}

pub fn toggle_cell(universe: Universe, position: Position) -> Universe {
  let cell = case find_cell(universe, position) {
    #(p, Dead) -> #(p, Alive)
    #(p, Alive) -> #(p, Dead)
  }

  [
    cell,
    ..universe
    |> list.filter(fn(x) {
      case x {
        #(p, _) if p == position -> False
        _ -> True
      }
    })
  ]
}
