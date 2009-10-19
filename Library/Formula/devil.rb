require 'formula'

class Devil <Formula
  url 'http://prdownloads.sourceforge.net/openil/1.7.8/DevIL-1.7.8.tar.gz'
  homepage 'http://sourceforge.net/projects/openil/'
  md5 '7918f215524589435e5ec2e8736d5e1d'
  
  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-ILU", "--enable-ILUT"
    system "make install"
  end
end
__END__
--- /src-ILU/ilur/ilur.c
+++ (clipboard)
@@ -1,6 +1,6 @@
 #include <string.h>
 #include <stdio.h>
-#include <malloc.h>
+// #include <malloc.h>
 
 #include <IL/il.h>
 #include <IL/ilu.h>
