require 'formula'

class Drush <Formula
  url 'http://ftp.drupal.org/files/projects/drush-All-Versions-2.1.tar.gz'
  homepage 'http://drupal.org/project/drush'
  md5 'dd4b55c7d1e98f35c51c69788d6dffee'

  def patches
    {:p0 => DATA}
  end

  def install
    bin.install "drush"
    prefix.install Dir["*"]-["drush"]
  end
end
__END__
--- drush
+++ (clipboard)
@@ -22,7 +22,7 @@
 cd "$ORIGDIR"

 # Build the path to drush.php.
-SCRIPT_PATH=$(dirname $SELF_PATH)/drush.php
+SCRIPT_PATH=$(dirname $SELF_PATH)/../drush.php
 [[ $(uname -a) == CYGWIN* ]] && SCRIPT_PATH=$(cygpath -w -a -- "$SCRIPT_PATH")

 # If it is not exported determine and export the number of columns.
