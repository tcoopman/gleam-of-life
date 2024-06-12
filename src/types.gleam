pub type CellStatus {
  Alive
  Dead
}

pub type Neighbours =
  List(CellStatus)

pub type LifeCycle {
  Dies
  Revives
  Same
}

pub type Position =
  #(Int, Int)

pub type Cell =
  #(Position, CellStatus)

pub type Universe =
  List(Cell)

pub type ViewPort {
  ViewPort(x_min: Int, y_min: Int, x_max: Int, y_max: Int, cell_size: Int)
}

pub type Model {
  Model(
    universe: Universe,
    examples: List(#(String, Universe)),
    view_port: ViewPort,
    running: Bool,
  )
}

pub type Msg {
  NoOp
  Evolve
  UpdateUniverse(String)
  ToggleRunning
  ToggleCell(Position)
  ZoomOut
  ZoomIn
  Left
  Right
  Down
  Up
}
