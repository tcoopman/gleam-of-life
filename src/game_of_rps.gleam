import gleam/list
import gleam/pair
import gleam/result

import lustre
import lustre/attribute.{class}
import lustre/effect.{type Effect}
import lustre/element
import lustre/element/html
import lustre/event

import examples
import game_of_life.{evolve}
import types.{
  type Model, type Msg, Down, Evolve, Left, Model, NoOp, Right, ToggleCell,
  ToggleRunning, Up, UpdateUniverse, ViewPort,
}
import view.{view_universe}

fn init(_flags) -> #(Model, Effect(Msg)) {
  let examples = examples.examples()
  let assert [#(_, universe), ..] = examples
  #(
    Model(
      universe: universe,
      examples: examples,
      running: True,
      view_port: ViewPort(0, 0, 18, 18, 35),
    ),
    every(250, Evolve),
  )
}

fn view(model: Model) -> element.Element(Msg) {
  let play_or_pause_text = case model.running {
    True -> "⏸️"
    False -> "▶️"
  }
  let example_universes =
    list.map(model.examples, fn(example) {
      let #(label, _) = example
      html.button([event.on_click(UpdateUniverse(label))], [html.text(label)])
    })

  html.div([class("bg-gleamGray w-screen h-full")], [
    header(),
    html.div([class("flex flex-col justify-center items-center h-full gap-4")], [
      html.div([], [
        html.button(
          [class("text-5xl text-gleam"), event.on_click(ToggleRunning)],
          [html.text(play_or_pause_text)],
        ),
      ]),
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
    html.div([class("p-4 text-gleam flex flex-col gap-2 items-center")], [
      html.text("Load a different model"),
      html.div([class("flex gap-3 justify-center")], example_universes),
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
    Evolve ->
      case model.running {
        True -> Model(..model, universe: evolve(model.universe))
        False -> model
      }
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
    ToggleCell(position) ->
      Model(
        ..model,
        universe: game_of_life.toggle_cell(model.universe, position),
      )
    ToggleRunning -> Model(..model, running: !model.running)
    UpdateUniverse(label) -> {
      let new_universe =
        list.find(model.examples, fn(example) {
          case example {
            #(l, _) if l == label -> True
            _ -> False
          }
        })
        |> result.unwrap(#("", model.universe))
        |> pair.second

      Model(..model, universe: new_universe)
    }
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
