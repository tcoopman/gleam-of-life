import examples
import lustre
import lustre/attribute.{class}
import lustre/element
import lustre/element/html
import types.{type Model, type Msg, Model, ViewPort}
import view.{view_universe}

fn init(_flags) -> Model {
  Model(
    universe: examples.blinker(),
    examples: [#("blinker", examples.blinker())],
    running: True,
    view_port: ViewPort(0, 0, 10, 10, 35),
  )
}

fn view(model: Model) -> element.Element(Msg) {
  html.div([class("m-4")], [
    header(),
    html.div([], []),
    view_universe(model.view_port, model.universe),
  ])
}

fn header() -> element.Element(Msg) {
  html.div([class("bg-green-200")], [html.text("header")])
}

fn update(model: Model, msg: Msg) -> Model {
  model
}

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}
