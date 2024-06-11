import lustre
import lustre/attribute.{class}
import lustre/effect.{type Effect}
import lustre/element
import lustre/element/html
import lustre/event

import examples
import game_of_life.{evolve}
import types.{
  type Model, type Msg, Down, Evolve, Left, Model, NoOp, Right, Up, ViewPort,
}
import view.{view_universe}

fn init(_flags) -> #(Model, Effect(Msg)) {
  #(
    Model(
      universe: examples.pulsar(),
      examples: [#("blinker", examples.blinker())],
      running: True,
      view_port: ViewPort(0, 0, 18, 18, 35),
    ),
    every(250, Evolve),
  )
}

fn view(model: Model) -> element.Element(Msg) {
  html.div([class("bg-gleamGray w-screen h-screen")], [
    header(),
    html.div([class("flex flex-col justify-center items-center h-full gap-4")], [
      html.div([], [
        html.button([class("text-5xl text-gleam"), event.on_click(Up)], [
          html.text("⬆️"),
        ]),
      ]),
      html.div([class("flex gap-2")], [
        html.button([class("text-5xl text-gleam"), event.on_click(Left)], [
          html.text("⬅️"),
        ]),
        view_universe(model.view_port, model.universe),
        html.button([class("text-5xl text-gleam"), event.on_click(Right)], [
          html.text("➡️"),
        ]),
      ]),
      html.div([], [
        html.button([class("text-5xl text-gleam"), event.on_click(Down)], [
          html.text("⬇️"),
        ]),
      ]),
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
    Left ->
      Model(
        ..model,
        view_port: ViewPort(
          ..model.view_port,
          x_min: model.view_port.x_min - 1,
          x_max: model.view_port.x_max - 1,
        ),
      )
    Right ->
      Model(
        ..model,
        view_port: ViewPort(
          ..model.view_port,
          x_min: model.view_port.x_min + 1,
          x_max: model.view_port.x_max + 1,
        ),
      )
    Up ->
      Model(
        ..model,
        view_port: ViewPort(
          ..model.view_port,
          y_min: model.view_port.y_min - 1,
          y_max: model.view_port.y_max - 1,
        ),
      )
    Down ->
      Model(
        ..model,
        view_port: ViewPort(
          ..model.view_port,
          y_min: model.view_port.y_min + 1,
          y_max: model.view_port.y_max + 1,
        ),
      )
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
