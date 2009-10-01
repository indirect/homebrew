require 'brewkit'

class RubyReadline < ScriptFileFormula
  # This is an attempt to fix readline in Snow Leopard's irb,
  #  following the directions in this blog post:
  homepage "http://henrik.nyh.se/2008/03/irb-readline"
  version "v1_8_7_72"
  url "http://svn.ruby-lang.org/repos/ruby/tags/#{@version}/ext/readline/"
  md5 "235f24dce92e3d92c515dd24af7841ff"

  def download_strategy
    SubversionDownloadStrategy
  end

  depends_on 'readline'

  def patches
    # This seems to be the only way to set flags for the actual build? Blech.
    {:p0 => DATA}
  end

  def install
    ENV.universal
    system "ruby extconf.rb"
    system "make"
    puts prefix.to_s
    prefix.install "readline.bundle"
    system "ln -sf #{prefix}/readline.bundle /Library/Ruby/Site/1.8/universal-darwin10.0/readline.bundle"
  end

  def caveats
    "This installs a symlink outside of the homebrew directory!\n" +
    "You'll need to remove /Library/Ruby/Site/1.8/universal-darwin10.0/readline.bundle to uninstall it completely."
  end
end
__END__
--- extconf.rb
+++ (clipboard)
@@ -1,5 +1,8 @@
 require "mkmf"

+$CFLAGS << " -arch x86_64 -arch i386 -arch ppc7400 -I/usr/local/include "
+$LDFLAGS << " -arch x86_64 -arch i386 -arch ppc7400 -L/usr/local/lib "
+
 $readline_headers = ["stdio.h"]

 def have_readline_header(header)
