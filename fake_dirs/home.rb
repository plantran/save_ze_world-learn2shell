class HomeDir < FakeDir
  def initialize
    @path = "home"
    @list = [
      {name: 'Planètes', slug: 'planetes', removable: false, locked: false, kind: :dir, target: $planetes_dir},
      {name: 'Analyses', slug: 'analyses', removable: false, locked: false, kind: :dir, target: $analyses_dir},
      {name: 'Securité', slug: 'securite', removable: false, locked: false, kind: :dir, target: $security_dir},
      {name: 'Admin', slug: 'admin', removable: false, locked: false, kind: :dir, target: $admin_dir}
    ]
    @list.each { |l| l[:target].parent_dir = self if l[:target]}
  end

  # def cd args
  #   return self unless validate_path(args)
  #   case args.first
  #   when 'security'
  #     $security_dir
  #   when 'admin'
  #     $admin_dir
  #   else
  #     puts "Le dossier n'a pas été trouvé."
  #     self
  #   end
  # end
end
