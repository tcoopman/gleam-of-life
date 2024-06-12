import gleam/list
import gleam/string

import types.{type Position, type Universe, Alive}

fn create(positions: List(Position)) -> Universe {
  list.map(positions, fn(position) { #(position, Alive) })
}

pub fn examples() {
  [
    #("Blinker", blinker()),
    #("Space ship", space_ship()),
    #("Pulsar", pulsar()),
    #("Glider", glider()),
    #("Bakers dozen", bakers_dozen()),
    #("Thunderbird", thunderbird()),
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

fn glider() {
  "
........................O...........
......................O.O...........
............OO......OO............OO
...........O...O....OO............OO
OO........O.....O...OO..............
OO........O...O.OO....O.O...........
..........O.....O.......O...........
...........O...O....................
............OO......................
"
  |> from_plain_text
}

fn bakers_dozen() {
  "
OO.........OO
OOOO.O.....OO
O.O..OOO
...........O
....OO....O.O
....O.....O..O....O
...........OO....OO

...............OOO..O.O
..........OO.....O.OOOO
..........OO.........OO
"
  |> from_plain_text
}

fn thunderbird() {
  "
OOO

.O
.O
.O
"
  |> from_plain_text
}

fn from_plain_text(str: String) -> types.Universe {
  str
  |> string.split("\n")
  |> list.index_map(line_to_universe)
  |> list.concat
}

fn line_to_universe(input: String, x: Int) {
  let chars = explode(input)
  list.index_map(chars, fn(c, y) { to_position(x, y, c) })
}

fn to_position(x: Int, y: Int, s: String) {
  case s {
    "O" -> #(#(x, y), types.Alive)
    _ -> #(#(x, y), types.Dead)
  }
}

fn explode(s: String) {
  exp(s, string.length(s), [])
}

fn exp(s: String, i: Int, l) {
  case i < 0 {
    True -> l
    False -> exp(s, i - 1, [string.slice(s, i, 1), ..l])
  }
}
