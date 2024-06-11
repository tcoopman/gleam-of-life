import lustre
import lustre/attribute.{class}
import lustre/effect.{type Effect}
import lustre/element
import lustre/element/html

import examples
import game_of_life.{evolve}
import types.{type Model, type Msg, Evolve, Model, NoOp, ViewPort}
import view.{view_universe}

fn init(_flags) -> #(Model, Effect(Msg)) {
  #(
    Model(
      universe: examples.pulsar(),
      examples: [#("blinker", examples.blinker())],
      running: True,
      view_port: ViewPort(0, 0, 20, 20, 35),
    ),
    every(100, Evolve),
  )
}

fn view(model: Model) -> element.Element(Msg) {
  html.div([class("bg-gleamGray w-screen h-screen")], [
    header(),
    html.div([class("flex justify-center items-center h-full")], [
      view_universe(model.view_port, model.universe),
    ]),
  ])
}

fn header() -> element.Element(Msg) {
  html.div([class("bg-gleam p-8 flex justify-center text-2xl leading-xl")], [
    html.text("Gleam Of Life"),
  ])
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(msg)) {
  let model = case msg {
    NoOp -> model
    Evolve -> Model(..model, universe: evolve(model.universe))
    _ -> todo
  }
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
