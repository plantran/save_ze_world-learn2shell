#!/usr/bin/env ruby

# TODO: CTRL + C
# TODO: EN | FR

require 'tty-prompt'
require 'rubygems'
require 'active_support/all'
# TODO: only for camelize and constantize

$prompt = TTY::Prompt.new(interrupt: false)

$admins = [
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

class User
  attr_reader :password, :name, :slug, :path

  def initialize
    @parent_dir = $users_dir
  end

  def cd args
    if args.empty?
      puts "Specify dir..."
      return self
    elsif args.first == ".."
      return @parent_dir
    else
      puts "Le dossier n'a pas été trouvé."
      return self
    end
  end

  def ls args
    if !args.empty? && args.first.strip == "-a"
      @list.each { |l| puts "#{l[:slug]}"}
    else
      @list.each { |l| puts "#{l[:slug]}" unless l[:hidden] == true}
    end
  end

  def cat args
    elem = @list.select { |l| l[:slug] == args.first and l[:kind] == :file }
    if !elem.blank?
      if elem.first[:locked]
        puts "Vous n'avez pas le droit de faire ça."
      else
        puts elem.first[:content]
      end
    else
      puts "Le fichier n'existe pas ou n'est pas un fichier."
    end
    self
  end

  def chmod args
    if args.empty?
      puts "Vos devez préciser un fichier."
    elsif args.count < 2
      puts "Vous devez préciser le mode et le fichier."
    else
      mode = args.first
      file = args[1]
      (puts "Le mode est incorrect, doit être: '+r'" ; return self) if mode != "+r"
      elem = @list.select { |l| l[:slug] == file and l[:kind] == :file }
      (puts "Le fichier n'a pas pu être trouvé" ; return self) if elem.empty?
      elem.first[:locked] = false
      puts "Les droits du fichier ont bien été modifié."
    end
    self
  end

  def rm args
    # TODO: Pas que dans cette classe
    if args.empty?
      puts "Vos devez préciser un fichier."
    else
      elem = @list.select { |l| l[:slug] == args.first.strip}
      (puts "Le fichier n'a pas pu être trouvé" ; return self) if elem.empty?
      (puts "Vous ne pouvez pas supprimer ce fichier." ; return self) if !elem.first[:removable]
      @list.delete_if { |l| l[:slug] == args.first.strip }
      puts "Le fichier a bien été supprimé."
    end
    self
  end

  def edit args
    (puts "Vos devez préciser un fichier." ; return self) if args.empty?
    elem = @list.select { |l| l[:slug] == args.first.strip}
    (puts "Le fichier n'a pas pu être trouvé" ; return self) if elem.empty?
    (puts "Vous n'avez pas le droit d'éditer ce fichier." ; return self) if elem.first[:locked]
    new_pwd = $prompt.ask("$ Nouveau mot de passe pour #{@path}: ")
    (puts "Le mot de passe n'a pas été sauvegardé" ; return self) if new_pwd.blank?
    @list.select { |l| l[:slug] == '.passwd' }.first[:content] = new_pwd
    @password = new_pwd
    $admins.select { |u| u[:slug] == @slug}.first[:password] = @password
    self
  end
end


# TODO: Faire heriter cette classe de fakedir aussi
$admins.each do |admin|
  klass_name = admin[:slug].camelize
  klass = Class.new(User) do
    define_method :initialize do
      @parent_dir = $users_dir
      @password = admin[:password]
      @name = admin[:name]
      @slug = admin[:slug]
      @path = @name
      @list = [ {name: "Passwd", slug: ".passwd", removable: false, locked: true, hidden: true, content: @password, kind: :file} ]
    end
  end
  Object.const_set(klass_name, klass)
end


# puts "francois_roublon".camelize.constantize.new.password

class FakeDir
  attr_reader :path
  def ls args
    @list.each { |l| puts "#{l[:slug]}\t\t"}
  end

  def cd_home

  end

  protected
  def validate_path args
    if args.empty?
      puts "Specify dir..."
      return false
    elsif (args.first == ".." and self.path == "home")
      puts "Cannot go furthur"
      return false
    end
    true
  end
end

class AdminDir < FakeDir

  def initialize
    @list = Array.new
    @path = "admin"
    @parent_dir = $home_dir
    # set
  end

  def cd args
    return self unless validate_path(args)
    return @parent_dir if (args.first == "..")
    slug = args.first
    # TODO: Creer
    # case slug
    # when ''
    #
    # end
  end

  protected
  def set
    $admins.each do |a|
      @list << a.merge({kind: :dir})
    end
  end
end

class PasswordDir < FakeDir
  def initialize
  end
end

class UsersDir < FakeDir
  def initialize
    @path = "utilisateurs"
    @parent_dir = $security_dir
    @list = Array.new()
    set_dirs
  end

  def cd args
    return self unless validate_path(args)
    return @parent_dir if (args.first == "..")
    slug = args.first
    (puts "Le dossier n'a pas été trouvé." ; return(self)) unless $admins.any? {|a| a[:slug] == slug}
    user = $admins.select { |u| u[:slug] == slug}.first
    pwd = $prompt.ask("$ Quel est le mot de passe pour cet utilisateur ? ") do |q|
      q.modify   :downcase
    end
    if pwd.strip == user[:password]
      puts "OK"
      return user[:slug].camelize.constantize.new
    else
      puts "Le mot de passe est erroné"
    end
    self
  end

  protected

  def set_dirs
    $admins.each do |a|
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
    return self unless validate_path(args)
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
  def initialize
    @list = [
      {name: 'Mots de passe', slug: 'mots_de_passe', removable: false, kind: :dir, target: $password_dir},
      {name: 'Utilisateurs', slug: 'utilisateurs', removable: false, kind: :dir, target: $users_dir},
    ]
    @path = "security"
    @parent_dir = $home_dir
  end

  def cd args
    return self unless validate_path(args)
    return @parent_dir if (args.first == "..")
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
    # $admins = set_admins
    $home_dir = HomeDir.new
    $admin_dir = AdminDir.new()
    $security_dir = SecurityDir.new
    $password_dir = PasswordDir.new()
    $users_dir = UsersDir.new()
    # @path = @home_dir.path
    # $current_dir = $home_dir
    # $current_dir = $security_dir
    @current_dir = $users_dir
    @current_dir = FrancoisRoublon.new
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
      @current_dir.ls(cmd_args)
    when 'cd'
      @current_dir = @current_dir.cd(cmd_args)
    when 'cat'
      @current_dir = @current_dir.cat(cmd_args)
    when 'chmod'
      @current_dir = @current_dir.chmod(cmd_args)
    when 'rm'
      @current_dir = @current_dir.rm(cmd_args)
    when 'edit'
      @current_dir = @current_dir.edit(cmd_args)
    else
      puts "La commande a mal été formulée."
    end
  end
end

# puts "toto".classify
# puts "toto_lol".camelize

@shell = Shell.new
@shell.display
