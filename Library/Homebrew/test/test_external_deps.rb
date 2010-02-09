require 'testing_env'

require 'test/unit' # must be after at_exit
require 'extend/ARGV' # needs to be after test/unit to avoid conflict with OptionsParser
ARGV.extend(HomebrewArgvExtension)

require 'utils'
require 'formula_installer'


class TestBall <Formula
  md5 '71aa838a9e4050d1876a295a9e62cbe6'

  # name parameter required for some Formula::factory
  def initialize name=nil
    @url="file:///#{Pathname.new(ABS__FILE__).parent.realpath}/testball-0.1.tbz"
    @homepage = 'http://example.com/'
    super "testball"
  end
  def install
    prefix.install "bin"
    prefix.install "libexec"
  end
end

# Custom formula installer that checks deps but does not
# run the install code.
class DontActuallyInstall < FormulaInstaller
  def install_private f ; end
end



class BadPerlBall <TestBall
  depends_on "notapackage" => :perl

  def initialize name=nil
    super "uses_perl_ball"
  end
end

class GoodPerlBall <TestBall
  depends_on "ENV" => :perl

  def initialize name=nil
    super "uses_perl_ball"
  end
end

class BadPythonBall <TestBall
  depends_on "notapackage" => :python

  def initialize name=nil
    super "uses_python_ball"
  end
end

class GoodPythonBall <TestBall
  depends_on "datetime" => :python

  def initialize name=nil
    super "uses_python_ball"
  end
end

class BadRubyBall <TestBall
  depends_on "notapackage" => :ruby

  def initialize name=nil
    super "uses_ruby_ball"
  end
end

class GoodRubyBall <TestBall
  depends_on "date" => :ruby

  def initialize name=nil
    super "uses_ruby_ball"
  end
end


class ExternalDepsTests < Test::Unit::TestCase
  def check_deps_fail f
    assert_raises(RuntimeError) do
      DontActuallyInstall.new.install f.new
    end
  end

  def check_deps_pass f
    assert_nothing_raised do
      DontActuallyInstall.new.install f.new
    end
  end


  def test_bad_perl_deps
    check_deps_fail BadPerlBall
  end

  def test_good_perl_deps
    check_deps_fail GoodPerlBall
  end

  def test_bad_python_deps
    check_deps_fail BadPythonBall
  end

  def test_good_python_deps
    check_deps_pass GoodPythonBall
  end

  def test_bad_ruby_deps
    check_deps_fail BadRubyBall
  end

  def test_good_ruby_deps
    check_deps_pass GoodRubyBall
  end
end
