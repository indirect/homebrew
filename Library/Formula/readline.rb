require 'brewkit'

class Readline <Formula
  @url='ftp://ftp.cwru.edu/pub/bash/readline-6.0.tar.gz'
  @homepage='http://tiswww.case.edu/php/chet/readline/rltop.html'
  @md5='b7f65a48add447693be6e86f04a63019'

  def keg_only? ; <<-EOS
OS X provides the BSD Readline library. In order to prevent conflicts when
programs look for libreadline we are defaulting this GNU Readline installation
to keg-only.
    EOS
  end

  def patches
    if MACOS_VERSION == 10.5
      (1..4).collect {|n| "ftp://ftp.gnu.org/gnu/readline/readline-6.0-patches/readline60-%03d"%n}
    else
      # originally from http://trac.macports.org/export/57883/trunk/dports/devel/readline/files/patch-shobj-conf.diff
      {:p0 => DATA}
    end
  end

  def install
    ENV.universal # doh. but I want IRB so bad

    # cargo-culting from MacPorts, where it says:
    #   Answers to questions configure can't determine without running a program.
    File.open("config.cache", "w"){|f| f.write(
      "bash_cv_must_reinstall_sighandlers=no\n" +
      "bash_cv_func_sigsetjmp=present\n" +
      "bash_cv_func_strcoll_broken=no\n" +
      "bash_cv_func_ctype_nonascii=yes\n"
    )}

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
  end
end

__END__
--- support/shobj-conf.orig	2009-01-04 14:32:42.000000000 -0500
+++ support/shobj-conf	2009-03-06 23:36:29.000000000 -0500
@@ -152,13 +152,13 @@

 	SHOBJ_CFLAGS='-fno-common'

-	SHOBJ_LD='MACOSX_DEPLOYMENT_TARGET=10.3 ${CC}'
+	SHOBJ_LD='${CC}'

 	SHLIB_LIBVERSION='$(SHLIB_MAJOR)$(SHLIB_MINOR).$(SHLIB_LIBSUFF)'
 	SHLIB_LIBSUFF='dylib'

-	SHOBJ_LDFLAGS='-dynamiclib -dynamic -undefined dynamic_lookup -arch_only `/usr/bin/arch`'
-	SHLIB_XLDFLAGS='-dynamiclib -arch_only `/usr/bin/arch` -install_name $(libdir)/$@ -current_version $(SHLIB_MAJOR)$(SHLIB_MINOR) -compatibility_version $(SHLIB_MAJOR) -v'
+	SHOBJ_LDFLAGS='-dynamiclib -dynamic -undefined dynamic_lookup'
+	SHLIB_XLDFLAGS='-dynamiclib -install_name $(libdir)/${@:$(SHLIB_MAJOR)$(SHLIB_MINOR).$(SHLIB_LIBSUFF)=$(SHLIB_MAJOR).$(SHLIB_LIBSUFF)} -current_version $(SHLIB_MAJOR)$(SHLIB_MINOR)000 -compatibility_version $(SHLIB_MAJOR) -v'

 	SHLIB_LIBS='-lncurses'	# see if -lcurses works on MacOS X 10.1
 	;;
@@ -176,10 +176,10 @@

 	case "${host_os}" in
 	darwin[789]*|darwin10*)	SHOBJ_LDFLAGS=''
-			SHLIB_XLDFLAGS='-dynamiclib -arch_only `/usr/bin/arch` -install_name $(libdir)/$@ -current_version $(SHLIB_MAJOR)$(SHLIB_MINOR) -compatibility_version $(SHLIB_MAJOR) -v'
+			SHLIB_XLDFLAGS='-dynamiclib -install_name $(libdir)/${@:$(SHLIB_MAJOR)$(SHLIB_MINOR).$(SHLIB_LIBSUFF)=$(SHLIB_MAJOR).$(SHLIB_LIBSUFF)} -current_version $(SHLIB_MAJOR)$(SHLIB_MINOR)000 -compatibility_version $(SHLIB_MAJOR) -v'
 			;;
 	*)		SHOBJ_LDFLAGS='-dynamic'
-			SHLIB_XLDFLAGS='-arch_only `/usr/bin/arch` -install_name $(libdir)/$@ -current_version $(SHLIB_MAJOR)$(SHLIB_MINOR) -compatibility_version $(SHLIB_MAJOR) -v'
+			SHLIB_XLDFLAGS='-install_name $(libdir)/${@:$(SHLIB_MAJOR)$(SHLIB_MINOR).$(SHLIB_LIBSUFF)=$(SHLIB_MAJOR).$(SHLIB_LIBSUFF)} -current_version $(SHLIB_MAJOR)$(SHLIB_MINOR)000 -compatibility_version $(SHLIB_MAJOR) -v'
 			;;
 	esac

