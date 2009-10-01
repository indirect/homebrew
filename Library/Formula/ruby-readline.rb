require 'brewkit'

class RubyReadline < ScriptFileFormula
  # This is an attempt to fix readline in Snow Leopard's irb.
  # Supposedly it is possible to compile a universal readline
  #   and link this library against it to gain readline with
  #   Apple's default install of ruby. Doesn't seem to work yet.
  homepage "http://henrik.nyh.se/2008/03/irb-readline"
  version "v1_8_7_72"
  url "http://svn.ruby-lang.org/repos/ruby/tags/#{@version}/ext/readline/"
  md5 "235f24dce92e3d92c515dd24af7841ff"

  def download_strategy
    SubversionDownloadStrategy
  end

  def patches
    # This really shouldn't be necessary, but it's not working yet, so :P
    {:p0 => DATA}
  end

  def install
    ENV.universal
    system "ruby extconf.rb"
    system "make install"
  end
end
__END__
--- extconf.rb.orig
+++ extconf.rb
@@ -1,5 +1,8 @@
 require "mkmf"

+$CFLAGS << " -I/usr/local/include "
+$LDFLAGS << " -L/usr/local/lib "
+
 $readline_headers = ["stdio.h"]
