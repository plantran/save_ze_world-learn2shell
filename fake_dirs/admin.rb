class AdminDir < FakeDir
  def initialize
    @path = "admin"
    @list = [
      {name: "Mot de passe", slug: ".mpd", locked: true, removable: false, hidden: true, editable: false, kind: file}
    ]
  end
end

class Admin < FakeDir
end
