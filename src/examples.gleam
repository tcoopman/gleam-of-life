import gleam/list
import types.{type Position, type Universe, Alive}

fn create(positions: List(Position)) -> Universe {
  list.map(positions, fn(position) { #(position, Alive) })
}

pub fn blinker() {
  create([#(1, 1), #(2, 1), #(3, 1)])
}

pub fn space_ship() {
  create([#(2, 0), #(0, 1), #(2, 1), #(1, 2), #(2, 2)])
}
