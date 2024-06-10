import lustre
import lustre/attribute.{class}
import lustre/effect.{type Effect}
import lustre/element
import lustre/element/html

import examples
import types.{type Model, type Msg, Evolve, Model, ViewPort}
import view.{view_universe}

fn init(_flags) -> #(Model, Effect(Msg)) {
  #(
    Model(
      universe: examples.blinker(),
      examples: [#("blinker", examples.blinker())],
      running: True,
      view_port: ViewPort(0, 0, 10, 10, 35),
    ),
    every(500, Evolve),
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

fn update(model: Model, msg: Msg) -> #(Model, Effect(msg)) {
  #(model, effect.none())
}

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

// app.gleam
fn every(interval: Int, tick: msg) -> Effect(msg) {
  effect.from(fn(dispatch) { do_every(interval, fn() { dispatch(tick) }) })
}

@external(javascript, "./ffi.mjs", "every")
fn do_every(interval: Int, cb: fn() -> Nil) -> Nil {
  Nil
}
