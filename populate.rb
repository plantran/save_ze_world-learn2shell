

def faker_analyse user
  address = "#{Faker::Address.street_address} - #{Faker::Address.zip_code} - #{Faker::Address.city}"
  f = "adresse = #{address}\n"
  f += "telephone = #{Faker::PhoneNumber.cell_phone}\n"
  f += "age = #{user[:age]}\n"
  f += "numero de carte bleue = #{user[:code_cb]}\n"
  f += "groupe sanguin = #{user[:blood]}\n"
  f += "activer les cameras = oui\n"
end

def new_user_class user
  klass = class_exists?("User#{user[:name].camelize}")
  return klass if klass
  t1 = Time.now
  t2 = Time.parse("2019-11-16 14:40:34")
  klass_name = "User#{user[:name].camelize}"
  klass = Class.new(User) do
    class_variable_set(:@@age, user[:age])
    class_variable_set(:@@blood, user[:blood])
    class_variable_set(:@@code_cb, user[:code_cb])
    define_method :initialize do
      @camera_activated = true
      @analized = true
      @parent_dir = $users_dir
      @name = user[:name]
      # @slug = user[:name].downcase
      @list = [
        {name: "Prochaine analyse", slug: "prochaine-analyse", removable: true, locked: false, content: "Prochaine analyse: #{rand(t1..t2)}", kind: :file, editable: true},
        {name: "Dernière analyse", slug: 'derniere-analyse', removable: false, locked: false, content: faker_analyse(user), kind: :file, editable: true}
      ]
      @path = user[:name].downcase
    end
  end
  Object.const_set(klass_name, klass)
end


def populate_users
  users = [
    {:name=>"Clement", :blood=>"B+", :code_cb=>"7465848869808880", :age=>11},
    {:name=>"Camille", :blood=>"B-", :code_cb=>"8566768483867886", :age=>14},
    {:name=>"Mathis", :blood=>"A-", :code_cb=>"8268847766847577", :age=>11},
    {:name=>"Maxime", :blood=>"A-", :code_cb=>"7783886765887790", :age=>12},
    {:name=>"Lucas", :blood=>"AB-", :code_cb=>"6687748872766972", :age=>16},
    {:name=>"Sarah", :blood=>"B+", :code_cb=>"7988737190886773", :age=>11},
    {:name=>"Maelys", :blood=>"A-", :code_cb=>"8490856968818478", :age=>13},
    {:name=>"Lena", :blood=>"A-", :code_cb=>"7089806984906671", :age=>16},
    {:name=>"Chloe", :blood=>"A-", :code_cb=>"6882667171687075", :age=>14},
    {:name=>"Arthur", :blood=>"A+", :code_cb=>"7180656968816767", :age=>15},
    {:name=>"Manon", :blood=>"A-", :code_cb=>"7769687468846583", :age=>13},
    {:name=>"Leo", :blood=>"A+", :code_cb=>"8578707067867577", :age=>12},
    {:name=>"Nathan", :blood=>"A+", :code_cb=>"8789888277767779", :age=>11},
    {:name=>"Matheo", :blood=>"B+", :code_cb=>"7169716783666784", :age=>12},
    {:name=>"Yanis", :blood=>"AB-", :code_cb=>"6981737677746772", :age=>11},
    {:name=>"Romane", :blood=>"AB-", :code_cb=>"6684737977737590", :age=>15},
    {:name=>"Gabriel", :blood=>"A-", :code_cb=>"8588877486798767", :age=>11},
    {:name=>"Ines", :blood=>"AB-", :code_cb=>"7584747465657882", :age=>16},
    {:name=>"Emma", :blood=>"AB-", :code_cb=>"7883717085908465", :age=>11},
    {:name=>"Louise", :blood=>"A+", :code_cb=>"6866756967767384", :age=>11},
    {:name=>"Louna", :blood=>"AB-", :code_cb=>"8185757290877470", :age=>13},
    {:name=>"Hugo", :blood=>"AB+", :code_cb=>"9086778270896867", :age=>16},
    {:name=>"Raphael", :blood=>"O-", :code_cb=>"9089828389787285", :age=>14},
    {:name=>"Jules", :blood=>"AB+", :code_cb=>"6966738981776969", :age=>14},
    {:name=>"Zoe", :blood=>"B+", :code_cb=>"7979676888908989", :age=>11},
    {:name=>"Noah", :blood=>"O+", :code_cb=>"7782828581657388", :age=>14},
    {:name=>"Theo", :blood=>"B-", :code_cb=>"8884848667777386", :age=>16},
    {:name=>"Tom", :blood=>"AB+", :code_cb=>"7884838784847986", :age=>16},
    {:name=>"Louis", :blood=>"B+", :code_cb=>"7565757685908383", :age=>14},
    {:name=>"Eva", :blood=>"AB-", :code_cb=>"7775898778798089", :age=>15},
    {:name=>"Lola", :blood=>"A-", :code_cb=>"7486698266667689", :age=>14},
    {:name=>"Anais", :blood=>"B-", :code_cb=>"8874717869668685", :age=>12},
    {:name=>"Clara", :blood=>"O+", :code_cb=>"6873678486678166", :age=>11},
    {:name=>"Lea", :blood=>"AB+", :code_cb=>"8374897573808587", :age=>12},
    {:name=>"Timeo", :blood=>"B+", :code_cb=>"7077737876666987", :age=>16},
    {:name=>"Lilou", :blood=>"A-", :code_cb=>"8783886672907969", :age=>12},
    {:name=>"Enzo", :blood=>"AB-", :code_cb=>"7976858288828579", :age=>11},
    {:name=>"Lina", :blood=>"AB+", :code_cb=>"8769678090798780", :age=>11},
    {:name=>"Ethan", :blood=>"A+", :code_cb=>"8974758968876871", :age=>15},
    {:name=>"Jade", :blood=>"O-", :code_cb=>"6565847482757487", :age=>15}
  ]
  users.each do |user|
    new_user_class(user)
  end
end
