# if [ -d "${HOME}/.brew" ]; then
# 	brew update
# fi
# export PATH="${HOME}/.rvm/gems/ruby-2.2.3/bin:${HOME}/.brew/bin:${PATH}"
# brew update
# brew install gpg2
#
# cd ${HOME}/
# \curl -sSL https://get.rvm.io | bash -s stable
# source /Users/bnoufel/.rvm/scripts/rvm
# rvm autolibs read-fail
# rvm install 2.2.3
# rvm use 2.2.3
# gem install --source http://rubygems.org/ bundler

gem install bundler --source http://rubygems.org --user
export PATH=$PATH:/Users/plantran/.gem/ruby/2.0.0/bin
bundle install --path $HOME/.gem/
