class PlanetDir < FakeDir
  def initialize

  end
end

def populate_planets
  planets = [{name: "Terre", slug: "terre", removable: false, locked: false, kind: :dir},
  {name: "Mars", slug: "mars", removable: false, locked: false, kind: :dir },
  {name: "Saturne", slug: "saturne", removable: false, locked: false, kind: :dir},
  {name: "Jupiter", slug: "jupiter", removable: false, locked: false, kind: :dir}]

  planets.each do |pl|
    klass_name = "Planet#{pl[:name].camelize}"
    klass = class_exists?(klass_name)
    return klass if klass
    t1 = Time.now
    t2 = Time.parse("2019-11-16 14:40:34")
    klass = Class.new(PlanetDir) do
      # class_variable_set(:@@age, user[:age])
      define_method :initialize do
        @slug = pl[:name].downcase
        @path = pl[:name].downcase
        @list = [
          {name: "Prochaine analyse", slug: "prochaine-analyse", removable: true, locked: false, content: "Prochaine analyse: #{rand(t1..t2)}", kind: :file, editable: true}
        ]
      end
    end
    Object.const_set(klass_name, klass)
  end
end
