require_relative '_base'

class PlanetesDir < FakeDir
  def initialize
    @path = "planetes"
    @list = [
      {name: "Terre", slug: "terre", removable: false, locked: false, kind: :dir, target: "PlanetTerre".constantize.new},
      {name: "Mars", slug: "mars", removable: false, locked: false, kind: :dir, target: "PlanetMars".constantize.new },
      {name: "Saturne", slug: "saturne", removable: false, locked: false, kind: :dir, target: "PlanetSaturne".constantize.new},
      {name: "Jupiter", slug: "jupiter", removable: false, locked: false, kind: :dir, target: "PlanetJupiter".constantize.new}
    ]
    set_parent_dir
  end

  private
  def set_parent_dir
    @list.each  { |l| l[:target].parent_dir = self }
  end
end
