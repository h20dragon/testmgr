

module Testmgr

  class AbstractTest
    attr_reader :name
    attr_reader :id
    attr_reader :xpath

    def initialize(name)
      @name=name
      @xpath=nil
      @id=nil
    end

    # Virtual
    def get_time_required
      raise "Abstract"
    end
    # Virtual
    def child(name)
      raise 'Abstract'
    end
    # Virtual
    def print
      raise "Abstract"
    end

  end  # Task

end
