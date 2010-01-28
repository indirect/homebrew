require 'formula'

class Gx <Formula
  head 'git://github.com/evanphx/gx.git'
  homepage 'http://github.com/evanphx/gx/'

  depends_on :grit => :ruby

  def install
    mkdir bin
    prefix.install(Dir['*'])
    %w(git-publish.rb git-update.rb).each do |f|
      ln_s prefix+f, bin+File.basename(f, '.rb')
      (prefix+f).chmod_R 0755
    end
  end
end
