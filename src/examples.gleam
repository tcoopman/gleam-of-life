import gleam/list
import types.{type Position, type Universe, Alive}

fn create(positions: List(Position)) -> Universe {
  list.map(positions, fn(position) { #(position, Alive) })
}

pub fn examples() {
  [
    #("Blinker", blinker()),
    #("Space ship", space_ship()),
    #("Pulsar", pulsar()),
  ]
}

fn blinker() {
  create([#(1, 1), #(2, 1), #(3, 1)])
}

fn space_ship() {
  create([#(2, 0), #(0, 1), #(2, 1), #(1, 2), #(2, 2)])
}

fn pulsar() {
  create([
    #(4, 2),
    #(5, 2),
    #(6, 2),
    #(10, 2),
    #(11, 2),
    #(12, 2),
    #(2, 4),
    #(7, 4),
    #(9, 4),
    #(14, 4),
    #(2, 5),
    #(7, 5),
    #(9, 5),
    #(14, 5),
    #(2, 6),
    #(7, 6),
    #(9, 6),
    #(14, 6),
    #(4, 7),
    #(5, 7),
    #(6, 7),
    #(10, 7),
    #(11, 7),
    #(12, 7),
    #(4, 9),
    #(5, 9),
    #(6, 9),
    #(10, 9),
    #(11, 9),
    #(12, 9),
    #(2, 10),
    #(7, 10),
    #(9, 10),
    #(14, 10),
    #(2, 11),
    #(7, 11),
    #(9, 11),
    #(14, 11),
    #(2, 12),
    #(7, 12),
    #(9, 12),
    #(14, 12),
    #(4, 14),
    #(5, 14),
    #(6, 14),
    #(10, 14),
    #(11, 14),
    #(12, 14),
  ])
}
