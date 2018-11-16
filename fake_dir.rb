class FakeDir
  attr_reader :path

  def ls args=[]
    puts ""
    if !args.empty? && args.first.strip == "-a"
      @list.sort_by { |l| l[:slug] }.each { |l| puts "#{l[:slug]}"}
    else
      @list.sort_by { |l| l[:slug] }.each { |l| puts "#{l[:slug]}" unless l[:hidden] == true}
    end
  end

  def cat args
    puts ""
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

  def rm args
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
