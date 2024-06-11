import gleam/list

import lustre/attribute.{class, classes}
import lustre/element
import lustre/element/html

import game_of_life.{find_cell}
import types.{
  type Cell, type Msg, type Universe, type ViewPort, Alive, Dead, ViewPort,
}

fn select_row(view_port: ViewPort, universe: Universe) -> List(Cell) {
  list.range(view_port.x_min, view_port.x_max)
  |> list.map(fn(x) { #(x, view_port.y_min) })
  |> list.map(find_cell(universe, _))
}

fn view_row(view_port: ViewPort, universe: Universe) {
  let row = select_row(view_port, universe)
  html.div([class("flex")], list.map(row, view_cell(view_port.cell_size, _)))
}

fn view_cell(_size: Int, cell: Cell) -> element.Element(Msg) {
  let #(_position, status) = cell
  html.div(
    [
      classes([
        #("flex w-4 h-4 sm:w-6 sm:h-6 border-gray-400 m-[1px]", True),
        #("bg-alive", status == Alive),
        #("bg-dead", status == Dead),
      ]),
    ],
    [],
  )
}

pub fn view_universe(view_port: ViewPort, universe) {
  let rows_range = list.range(view_port.y_min, view_port.y_max)
  let row_view_port = fn(row) { ViewPort(..view_port, y_min: row, y_max: row) }
  let rows_view_port = list.map(rows_range, row_view_port)
  let rows = list.map(rows_view_port, view_row(_, universe))
  html.div([], rows)
}
