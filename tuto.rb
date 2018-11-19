# TODO: Faire tuto : qu'est ce que le prompt au début
include Curses

def screen_clear
  system "clear"
end

def nano filename
  system "nano -t #{filename}"
end

def display_letters str, speed=nil
  speed = speed || (1.0 / 30)
  str.split("").each do |c|
    print c
    sleep(speed)
  end
end


class Tuto
  def initialize
    @hint = Hint.new
    @help = HelpCommands.new
    @auth_logins = ["Vrezeok", "Krerrin", "Vrils", "Iktoks", "Daldrar", "Choldal", "Ghid", "Teivil", "Ruldeth", "Coknals", "Tenqids", "Korkeids", "Arkrils", "Ulmae", "Uval", "Yudda", "Khoknuts", "Gulxot", "Fodreas"]
    File.open("autorisations", "w+") {|f| f.puts @auth_logins.map {|l| l} }
    screen_clear
    # first_part
    second_part
    last_part
  end

  def first_part
    cursor = TTY::Cursor
    ascii_slant = Artii::Base.new(font: 'slant')
    a = Artii::Base.new
    puts ascii_spaceship
    puts a.asciify('XZ120F')
    introduction_str = "Bienvenue sur le système informatique du XZ120F, le plus grand vaisseau alien.\n"
    introduction_str += "Veuillez vous identifier en inscrivant votre prénom."
    display_letters(introduction_str)
    answer = nil
    puts "\n\n"
    while !answer
      answer = $prompt.ask("Prénom :") do |q|
        q.modify   :downcase
      end
    end
    Whirly.start spinner: "random_dots" do
      sleep 4
    end
    cursor.invisible {
      0.upto(5) do
        print "\r☠️   "
        sleep 0.4
        print "\r     "
        sleep 0.4
      end
    }
    screen_clear
    sleep 0.5
    puts ascii_slant.asciify('ACCES INTERDIT !').colorize(:red)
    puts @hint.infiltrate_computer
    puts @help.edit
    cmd = nil
    while !cmd || cmd.strip != 'edit autorisations'
      cmd = $prompt.ask("$> ") do |q|
        q.modify   :downcase
      end
      puts "Ce n'est pas la bonne commande." if !cmd || cmd.strip != 'edit autorisations'
    end
    user_name = add_self_name.first.split(' ').first
    new_user_class({ name: user_name, blood: "O+", code_cb: ((0...8).map { (65 + rand(26)) }.join), age: rand(11..16)})
    $current_user = "User#{user_name.camelize}".constantize.new
    puts @hint.rewrite_firstname($current_user.name)
    answer = nil
    while !answer || answer != $current_user.name
      answer = $prompt.ask("Prénom :") do |q|
        q.modify   :downcase
      end
    end
    Whirly.start spinner: "random_dots" do
      sleep 4
    end
    screen_clear
    sleep 0.5

    system "less alan_turing.less"
    puts ascii_slant.asciify('ACCES AUTORISE !').colorize(:green)
  end

  def second_part
    user_name = "paula"
    new_user_class({ name: user_name, blood: "O+", code_cb: ((0...8).map { (65 + rand(26)) }.join), age: rand(11..16)})
    $current_user = "User#{user_name.camelize}".constantize.new

    $users_dir = AnalysesDir.new()
    $users_dir.list << {name: $current_user.name, slug: $current_user.name.downcase, removable: false, locked: false, kind: :dir}
    #
    # puts @hint.after_authorized
    # puts @help.after_authorized
    #
    # cmd = nil
    # while !cmd || cmd.strip != 'ls'
    #   cmd = $prompt.ask("$> ") do |q|
    #     q.modify   :downcase
    #   end
    #   puts "Ce n'est pas la bonne commande." if !cmd || cmd.strip != 'ls'
    # end
    # $users_dir.ls
    # puts @hint.after_ls
    # puts @help.after_ls
    #
    # cmd = nil
    # while !cmd || cmd.strip != "cd #{$current_user.slug}"
    #   cmd = $prompt.ask("$> ") do |q|
    #     q.modify   :downcase
    #   end
    #   puts "Ce n'est pas la bonne commande." if !cmd || cmd.strip != "cd #{$current_user.slug}"
    # end
    #
    # puts @hint.after_cd
    #
    # cmd = nil
    # while !cmd || cmd.strip != 'ls'
    #   cmd = $prompt.ask("$ #{$current_user.name} > ") do |q|
    #     q.modify   :downcase
    #   end
    #   puts "Ce n'est pas la bonne commande." if !cmd || cmd.strip != 'ls'
    # end
    #
    # $current_user.ls
    #
    # puts @hint.after_enter_user
    # puts @help.after_enter_user
    #
    # cmd = nil
    # while !cmd || cmd.strip != 'cat prochaine-analyse'
    #   cmd = $prompt.ask("$ #{$current_user.name} > ") do |q|
    #     q.modify   :downcase
    #   end
    #   puts "Ce n'est pas la bonne commande." if !cmd || cmd.strip != 'cat prochaine-analyse'
    # end
    #
    # $current_user.cat(["prochaine-analyse"])
    #
    # puts @hint.after_cat
    # puts @help.after_cat
    #
    # cmd = nil
    # while !cmd || cmd.strip != 'rm prochaine-analyse'
    #   cmd = $prompt.ask("$ #{$current_user.name} > ") do |q|
    #     q.modify   :downcase
    #   end
    #   puts "Ce n'est pas la bonne commande." if !cmd || cmd.strip != 'rm prochaine-analyse'
    # end
    #
    # $current_user.rm(["prochaine-analyse"])
    #
    #
    # puts @hint.after_rm
    #
    # cmd = nil
    # while !cmd || cmd.strip != 'cat derniere-analyse'
    #   cmd = $prompt.ask("$ #{$current_user.name} > ") do |q|
    #     q.modify   :downcase
    #   end
    #   puts "Ce n'est pas la bonne commande." if !cmd || cmd.strip != 'cat derniere-analyse'
    # end
    #
    # $current_user.cat(["derniere-analyse"])
    #
    # puts @hint.after_cat_user
    #
    # cmd = nil
    # while !cmd || cmd.strip != 'rm derniere-analyse'
    #   cmd = $prompt.ask("$ #{$current_user.name} > ") do |q|
    #     q.modify   :downcase
    #   end
    #   puts "Ce n'est pas la bonne commande." if !cmd || cmd.strip != 'rm derniere-analyse'
    # end
    #
    # $current_user.rm(["derniere-analyse"])
    #
    # puts @hint.after_failed_rm
    # puts @help.edit("derniere-analyse")
    #
    # cmd = nil
    # while !cmd || cmd.strip != 'edit derniere-analyse'
    #   cmd = $prompt.ask("$ #{$current_user.name} > ") do |q|
    #     q.modify   :downcase
    #   end
    #   puts "Ce n'est pas la bonne commande." if !cmd || cmd.strip != 'edit derniere-analyse'
    # end
    # $current_dir = $current_user
    # $current_user.edit(["derniere-analyse"])
    #
    # system "less ada_lovelace.less"

  end

  def last_part
    screen_clear
    puts @hint.after_edit_analyse
    puts @help.after_edit_analyse
    $prompt.ask("Appuie sur entrée pour continuer...")
    $current_dir = $home_dir
    puts $current_dir.path
  end

  private

  def add_self_name
    nano "autorisations"
    file_logins = []
    f = File.open("autorisations", "r").read
    f.each_line do |l|
      name = l.gsub(/\s+/, "")
      file_logins << name unless name.empty?
    end
    diff = file_logins.sort - @auth_logins.sort
    if @auth_logins.count >= file_logins.count || diff.count > 1
      File.open("autorisations", "w+") {|fi| fi.puts @auth_logins.map {|l| l} }
      diff = add_self_name
    end
    File.delete("autorisations") if File.exist?("autorisations")
    return diff
  end

end
