#!/usr/bin/env ruby

# TODO: CTRL + C
# TODO: EN | FR
# TODO: only for camelize and constantize

require 'tty-prompt'
require 'tty-cursor'
require 'tty-table'
require 'rubygems'
require 'active_support/all'
require 'artii'
require 'whirly'
require 'paint'
require "curses"
require 'colorize'
require 'time'
require 'faker'
require 'securerandom'

Faker::Config.locale = 'fr'

class String
def bold;           "\e[1m#{self}\e[22m" end
def italic;         "\e[3m#{self}\e[23m" end
def underline;      "\e[4m#{self}\e[24m" end
def blink;          "\e[5m#{self}\e[25m" end
def reverse_color;  "\e[7m#{self}\e[27m" end
end

$prompt = TTY::Prompt.new(interrupt: false)

$admins = [
  {:name=>"Vrezeok", :slug=>"vrezeok", :password=>"90e51a2"},
  {:name=>"Krerrin", :slug=>"krerrin", :password=>"ff46339"},
  {:name=>"Vrils", :slug=>"vrils", :password=>"79e1fdc"},
  {:name=>"Iktoks", :slug=>"iktoks", :password=>"1fb301d"},
  {:name=>"Daldrar", :slug=>"daldrar", :password=>"597c2ff"},
  {:name=>"Choldal", :slug=>"choldal", :password=>"d2ee10e"},
  {:name=>"Ghid", :slug=>"ghid", :password=>"b84142a"},
  {:name=>"Teivil", :slug=>"teivil", :password=>"23fdbd6"},
  {:name=>"Ruldeth", :slug=>"ruldeth", :password=>"12fb8d3"},
  {:name=>"Coknals", :slug=>"coknals", :password=>"c28a979"},
  {:name=>"Tenqids", :slug=>"tenqids", :password=>"803d086"},
  {:name=>"Korkeids", :slug=>"korkeids", :password=>"f869410"},
  {:name=>"Arkrils", :slug=>"arkrils", :password=>"3833b6a"},
  {:name=>"Ulmae", :slug=>"ulmae", :password=>"55c869c"},
  {:name=>"Uval", :slug=>"uval", :password=>"d9955a1"},
  {:name=>"Yudda", :slug=>"yudda", :password=>"f52cabe"},
  {:name=>"Khoknuts", :slug=>"khoknuts", :password=>"9896128"},
  {:name=>"Gulxot", :slug=>"gulxot", :password=>"c27d749"},
  {:name=>"Fodreas", :slug=>"fodreas", :password=>"17e128d"}
]

def class_exists?(class_name)
  klass = Module.const_get(class_name)
  return klass.is_a?(Class)
rescue NameError
  return false
end

# require_relative 'fake_dir'
Dir["./fake_dirs/*.rb"].each {|file| require_relative file }

require_relative 'populate'

populate_users
populate_planets

$analyses_dir = AnalysesDir.new
$planetes_dir = PlanetesDir.new
$security_dir = SecurityDir.new
$admin_dir = AdminDir.new

$home_dir = HomeDir.new



# $admin_dir = AdminDir.new()
# $security_dir = SecurityDir.new
# $password_dir = PasswordDir.new()


require_relative 'hints_and_helps'
require_relative 'ascii_arts'

require_relative 'personnes'
require_relative 'tuto'



class AdminUser
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
  klass = Class.new(AdminUser) do
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



# class AdminDir < FakeDir
#
#   def initialize
#     @list = Array.new
#     @path = "admin"
#     @parent_dir = $home_dir
#     # set
#   end
#
#   def cd args
#     return self unless validate_path(args)
#     return @parent_dir if (args.first == "..")
#     slug = args.first
#   end
#
#   protected
#   def set
#     $admins.each do |a|
#       @list << a.merge({kind: :dir})
#     end
#   end
# end

class PasswordDir < FakeDir
  def initialize
  end
end

class AdminUsersDir < FakeDir
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

# class SecurityDir < FakeDir
#   def initialize
#     @list = [
#       {name: 'Mots de passe', slug: 'mots_de_passe', removable: false, kind: :dir, target: $password_dir},
#       {name: 'Utilisateurs', slug: 'utilisateurs', removable: false, kind: :dir, target: $users_dir},
#     ]
#     @path = "security"
#     @parent_dir = $home_dir
#   end
#
#   def cd args
#     return self unless validate_path(args)
#     return @parent_dir if (args.first == "..")
#     case args.first
#     when 'mots_de_passe'
#       $admin_dir
#     when 'utilisateurs'
#       $users_dir
#     else
#       puts "Le dossier n'a pas été trouvé."
#       self
#     end
#   end
# end


class Shell
  def initialize(path="home")
    # $admins = set_admins
    # $home_dir = HomeDir.new
    # $admin_dir = AdminDir.new()
    # $security_dir = SecurityDir.new
    # $password_dir = PasswordDir.new()
    # $users_dir = UsersDir.new()
    # @path = @home_dir.path
    $current_dir = $home_dir
    $current_dir = $security_dir
    # $current_dir = $security_dir
    # $current_dir = $users_dir
    # $current_dir = FrancoisRoublon.new
  end

  def display
    args = nil
    while !args || args.strip != "exit"
      args = $prompt.ask("$ #{$current_dir.path} >") do |q|
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
      $current_dir.ls(cmd_args)
    when 'cd'
      $current_dir.cd(cmd_args)
    when 'cat'
      $current_dir.cat(cmd_args)
    when 'chmod'
      $current_dir.chmod(cmd_args)
    when 'rm'
      $current_dir.rm(cmd_args)
    when 'edit'
      $current_dir.edit(cmd_args)
    when 'aide'
      system "less aide.less"
    else
      puts "La commande a mal été formulée."
    end
  end
end

# puts "toto".classify
# puts "toto_lol".camelize

# Tuto.new
@shell = Shell.new
@shell.display
