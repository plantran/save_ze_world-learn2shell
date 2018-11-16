class Hint

  def infiltrate_computer
    h = "\n\n"
    h += "💡  Conseil : Pour rentrer dans le système, il faut rajouter ton prénom dans la liste des utilisateurs autorisés !\n"
    h += "   Pour cela, édite le fichier " + "autorisations".italic + " et rajoute ton prénom !"
    h += "\n-----------\n"
  end

  def rewrite_firstname(name)
    h = "\n\n"
    h += "💡  Maintenant que tu as ajouté ton prénom (#{name}) à la liste des utilisateurs autorisés, tu peux le retaper pour rentrer dans le système !"
    h += "\n-----------\n\n"
  end

  def after_authorized
    h = "\n\n"
    h += "💡  Maintenant que tu es dans le système, tu vas pouvoir commencer à regarder ce qu'il s'y passe.\n"
    h += "    Voyons ce qu'il y a dans le dossier où tu es.."
    h += "\n-----------\n\n"
  end

  def after_ls
    h = "\n\n"
    h += "💡  Comme tu peux le voir, il y a des choses dans le dossier.\n"
    h += "    Les noms sont en gras et sont précédés d'un icône 🗂  , ça veut dire que ce sont d'autres dossiers. Regarde, il y a un dossier avec ton nom !\n"
    h += "    Ça veut dire que le système a des informations sur toi... Il vaut mieux aller rectifier ça tout de suite, va dans ton dossier pour faire ça."
    h += "\n-----------\n\n"
  end

  def after_cd
    h = "\n\n"
    h += "💡  Maintenant que tu es dans ton dossier, tu peux voir que ton nom est écrit au niveau du prompt ($>)\n"
    h += "    Ca veut dire que tu es bien dans ton dossier. Voyons maintenant ce qu'il y a dedans en se servant de la commande ls ."
    h += "\n-----------\n\n"
  end

  def after_enter_user
    h = "\n\n"
    h += "💡  Tu peux voir que ce qu'il y a à l'interieur de ce dossier sont des fichiers, car il n'y a pas l'icône 🗂  devant.\n"
    h += "    Voyons ce que contient le fichier " + "prochaine-analyse".italic + " !"
    h += "\n-----------\n\n"
  end

  def after_cat
    h = "\n\n"
    h += "💡  Mmmh... Une analyse ?? Ca n'a pas l'air très très bon pour toi... Mieux vaut annuler ça tout de suite et supprimer ce fichier !"
    h += "\n-----------\n\n"
  end

  def after_rm
    h = "\n\n"
    h += "💡  Super, maintenant que ce fichier a bien été supprimé, intéressons-nous au deuxième( derniere-analyse ). Affiche le contenu de ce fichier avec la commande " + "cat".italic
    h += "\n-----------\n\n"
  end

  def after_cat_user
    h = "\n\n"
    h += "💡  Il semblerait qu'il y ait beaucoup d'informations personnelles sur toi. Supprime ce fichier aussi avec la commande " + "rm".italic
    h += "\n-----------\n\n"
  end

  def after_failed_rm
    h = "\n\n"
    h += "💡  On ne peut pas supprimer ce fichier. Il faut l'éditer en mettant de fausses informations pour qu'on ne te retrouve pas !\n"
    h += "    Remplace ce qu'il y a après les '=' !"
    h += "\n-----------\n\n"
  end

  def after_edit_analyse
    h = "\n\n"
    h += "💡  Super, tu es maintenant intraçable sur le système informatique alien !\n"
    h += "    Maintenant, tu vas pouvoir commencer à détruire le vaisseau à distance..."
    h += "\n-----------\n\n"
  end

end

class HelpCommands

  def edit file=nil
    file = file || "autorisations"
    h = "💻  Commandes :\n"
    h += "   Pour éditer un fichier, tape la commande " + "edit".italic + " et le nom du fichier\n"
    h += "   que tu veux éditer derrière. Par exemple :\n"
    h += "   edit #{file}".italic
    h += "\n\n\n"
  end

  def after_authorized
    h = "💻  Commandes :\n"
    h += "   Pour voir ce qu'il y a dans le dossier où tu es, tu peux taper la commande " + "ls".italic + "\n"
    h += "   Par exemple :\n"
    h += "   ls".italic
    h += "\n\n\n"
  end

  def after_ls
    h = "💻  Commandes :\n"
    h += "   Pour aller dans un dossier, il faut utiliser la commande " + "cd".italic + " avec son nom juste après.\n"
    h += "   Par exemple :\n"
    h += "   cd mon_dossier".italic
    h += "\n\n\n"
  end

  def after_cd

  end

  def after_enter_user
    h = "💻  Commandes :\n"
    h += "   Pour afficher le contenu d'un fichier à l'écran, tape la commande " + "cat".italic + " suivi du nom du fichier.\n"
    h += "   Par exemple :\n"
    h += "   cat fichier".italic
    h += "\n\n\n"
  end

  def after_cat
    h = "💻  Commandes :\n"
    h += "   Pour supprimer un fichier, tape la commande " + "rm".italic + " suivi du nom du fichier.\n"
    h += "   Par exemple :\n"
    h += "   rm fichier".italic
    h += "\n\n\n"
  end
end
