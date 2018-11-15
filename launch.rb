#!/usr/bin/env ruby

# TODO: CTRL + C
# TODO: EN | FR

require 'tty-prompt'

$prompt = TTY::Prompt.new(interrupt: false)


class FakeDir
  attr_reader :path
  def ls
    @list.each { |l| puts "#{l[:slug]}\t\t"}
  end

  def cd args
    if args.empty?
      puts "Specify dir..."
      return(self)
    end
    if (args.first == ".." and self.path == "home")
      puts "Cannot go furthur"
      return(self)
    end
    return @parent_dir if (args.first == "..")
  end

  protected
  def validate_path
    
  end
end

class AdminDir < FakeDir
  def initialize(admins)
    @admins = admins
    @list = Array.new
    @path = "admin"
    set
  end
  protected
  def set
    @admins.each do |a|
      @list << a.merge({kind: :dir})
    end
  end
end

class PasswordDir < FakeDir
  def initialize

  end
end

class UsersDir < FakeDir
  def initialize(admins)
    @admins = admins
    @path = "utilisateurs"
    @parent_dir = $security_dir
    @list = Array.new()
    set_dirs
  end

  def cd args
    # TODO: trouver moyen return dans super
    if super
      puts "coucou"
      slug = args.first
      puts "Le dossier n'a pas été trouvé." and return(self) unless @admins.any? {|a| a[:slug] == slug}
      puts "SALUT"
      user = @admins.select { |u| u[:slug] == slug}.first
      pwd = $prompt.ask("$ Quel est le mot de passe pour cet utilisateur ? ") do |q|
        q.modify   :downcase
      end
      if pwd.strip == user[:password]
        puts "OK"
      else
        puts "Le mot de passe est erroné"
      end
    end

  end

  protected

  def set_dirs
    @admins.each do |a|
      @list << a.merge({kind: :dir, removable: :false})
    end
  end
end

class HomeDir < FakeDir
  def initialize
    @path = "home"
    @list = [
      {name: 'Security', slug: 'security', removable: false, kind: :dir, target: $security_dir},
      {name: 'Admin', slug: 'admin', removable: false, kind: :dir, target: $admin_dir}
    ]
  end

  def cd args
    return super
    case args.first
    when 'security'
      $security_dir
    when 'admin'
      $admin_dir
    else
      puts "Le dossier n'a pas été trouvé."
      self
    end
  end
end

class SecurityDir < FakeDir
  def initialize()
    @list = [
      {name: 'Mots de passe', slug: 'mots_de_passe', removable: false, kind: :dir, target: $password_dir},
      {name: 'Utilisateurs', slug: 'utilisateurs', removable: false, kind: :dir, target: $users_dir},
    ]
    @path = "security"
    @parent_dir = $home_dir
  end

  def cd args
    return super
    case args.first
    when 'mots_de_passe'
      $admin_dir
    when 'utilisateurs'
      $users_dir
    else
      puts "Le dossier n'a pas été trouvé."
      self
    end
  end

end


class Shell
  def initialize(path="home")
    @admins = set_admins
    $home_dir = HomeDir.new
    $admin_dir = AdminDir.new(@admins)
    $security_dir = SecurityDir.new
    $password_dir = PasswordDir.new()
    $users_dir = UsersDir.new(@admins)
    # @path = @home_dir.path
    # $current_dir = $home_dir
    # $current_dir = $security_dir
    @current_dir = $users_dir
  end

  def display
    args = nil
    while !args || args.strip != "exit"
      args = $prompt.ask("$ #{@current_dir.path} >") do |q|
        q.modify   :downcase
      end
      command_parse(args) if args
    end
  end

  def command_parse args
    cmd = args.strip.split.first
    cmd_args = args.strip.split.drop(1)
    case cmd
    when 'ls'
      $current_dir.ls
    when 'cd'
      @current_dir = @current_dir.cd(cmd_args)
    else
      puts "La commande a mal été formulée."
    end
  end

  # def cd args
  #   puts "Specify dir..." and return if args.empty?
  #   puts "Cannot go furthur" and return if (args.first == ".." and $current_dir.path == "home")
  #   case args.first
  #   when 'admin', $current_dir.path == "home"
  #     $current_dirx = $admin_dir
  #   when 'security', $current_dir.path == "home"
  #     $current_dir = $security_dir
  #   when 'home'
  #     $current_dir = $home_dir
  #   when '..'
  #   else
  #     puts "Le dossier n'a pas été trouvé."
  #   end
  # end

  protected

  def set_admins
    [
      {name: 'Francois Roublon', slug: 'francois_roublon', password: 'zsexdr1'},
      {name: 'Eric Delafre', slug: 'eric_delafre', password: 'xdrcft3'},
      {name: 'Elodie Etourneau', slug: 'elodie_etourneau', password: 'cfttfc3'},
      {name: 'Maeva Fares', slug: 'maeva_fares', password: 'vgyygv4'},
      {name: 'Max Bourdi', slug: 'max_bourdi', password: 'eszxdr6'},
      {name: 'Amhed Barakat', slug: 'amhed_barakat', password: 'okmbhu3'},
      {name: 'Jean Soummier', slug: 'jean_soummier', password: 'njiuhg7'},
      {name: 'Valerie Van der Meulen', slug: 'valerie_van_der_meulen', password: 'njiokl0'},
      {name: 'Juliette Soisson', slug: 'juliette_soisson', password: 'xdresv7'},
      {name: 'Lise Hautard', slug: 'lise_hautard', password: 'bhuijn5'},
      {name: 'Yvan Champeroux', slug: 'yvan_champeroux', password: 'cvbnhu2'},
      {name: 'Nicolas Peroteau', slug: 'nicolas_peroteau', password: 'njiuhbt'},
      {name: 'Franny Kilab', slug: 'franny_kilab', password: 'fghjkl8'},
      {name: 'Veronique Grangeon', slug: 'veronique_grangeon', password: 'cgydht6'},
      {name: 'Corinne Stermann', slug: 'corinne_stermann', password: 'bnhjui9'},
      {name: 'Denis Martin', slug: 'denis_martin', password: 'werfgt3'},
      {name: 'Mathieu Manley', slug: 'mathieu_manley', password: 'qwertgh2'},
      {name: 'Justine Juste', slug: 'justine_juste', password: 'qwdfgh7'}
    ]
  end
end

@shell = Shell.new
@shell.display
