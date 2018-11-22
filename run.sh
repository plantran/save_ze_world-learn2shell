if [ -d "${HOME}/.brew" ]; then
	brew update
fi
export PATH="${HOME}/.rvm/gems/ruby-2.2.3/bin:${HOME}/.brew/bin:${PATH}"
brew update
brew install gpg2

cd ${HOME}/
\curl -sSL https://get.rvm.io | bash -s stable
source /Users/bnoufel/.rvm/scripts/rvm
rvm autolibs read-fail
rvm install 2.2.3
rvm use 2.2.3
gem install --source http://rubygems.org/ bundler

