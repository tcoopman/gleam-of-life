import lustre
import lustre/attribute.{class}
import lustre/element
import lustre/element/html

type Model {
  Model(running: Bool)
}

type Msg

fn init(_flags) -> Model {
  Model(running: False)
}

fn view(model: Model) -> element.Element(Msg) {
  html.div([class("bg-green-500 p-4")], [html.text("running")])
}

fn update(model: Model, msg: Msg) -> Model {
  model
}

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}
