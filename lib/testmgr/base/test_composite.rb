

module Testmgr

  class TestComposite < AbstractTest
    attr_accessor :name
    attr_accessor :full_path
    attr_accessor :parent

    def initialize(name)
      super(name)
      @name=name
      @sub_tasks=[]
      @full_path = @name
      @parent=nil
    end

    def get_name
      @name
    end

    def get_parent
      @parent
    end

    def get_parents
      _parents=""
      _parents=@parent.get_name if @parent

      _p=@parent
      while _p && _p.get_parent do
        _parents = "#{_p.get_parent.get_name} => " + _parents
        _p=_p.get_parent
      end

      _parents
    end

    def set_parent(parent)
     # puts __FILE__ + (__LINE__).to_s + " CompositeTask::set_parent"
      @parent=parent
    end

    def add_sub_task(task)
      @sub_tasks << task
      task.set_parent(self)
      task
    end

    def add(r)
      add_sub_task(r)
    end

    def remove_sub_task(task)
      @sub_tasks.delete(task)
    end

    def get_time_required
      time=0.0
      @sub_tasks.each { |task| time += task.get_time_required }
    end

    def totalTestCases()
      @sub_tasks.length
    end

    def getResult()
      rc=true
      @sub_tasks.each do |task|
        rc = rc && task.getResult()
      end

      rc
    end

    def print
     # puts __FILE__ + (__LINE__).to_s + " -- print( #{@name} ) --"
      puts "REQ : #{@name} : #{@sub_tasks.length.to_s} test cases."
      @sub_tasks.each do |task|
     #   puts __FILE__ + (__LINE__).to_s + " ** #{task.class.to_s} **"
        task.print
      end
    end

    def getMetrics()
      m={:passed => 0, :failed => 0, :skipped => 0, :total => 0}
      @sub_tasks.each do |t|
        if t.is_a?(Testmgr::TestCase)
          _m = t.getMetrics()
          m[:total] += _m[:total]
          m[:passed] += _m[:passed]
          m[:failed] += _m[:failed]
          m[:skipped] += _m[:skipped]
        else
          puts __FILE__ + (__LINE__).to_s + " Unsure here."
        end
      end

      m
    end

    def tc(name)
      child(name)
    end

    def testcase(name)
      tc=child(name)

      if tc.nil?
        _tc = Testmgr::TestCase.new(name, name)
        tc=add(_tc)
      end

      tc
    end

    def child(name)
    #  puts __FILE__ + (__LINE__).to_s + " [search child]:#{name}"
      _child=nil

      @sub_tasks.each { |task|

      #  puts __FILE__ + (__LINE__).to_s + " o task( #{task.get_name} ) => #{task.class.to_s}"

        _c=task.child(name)
        if _c
        #  puts __FILE__ + (__LINE__).to_s + " Found => Name:#{_c.name}"
          _child=_c
        end
      }
      _child
    end

    def get_child(name)
      _c=child(name)

      if _c.nil?
        _c=testcase(name)
      end

    #  puts __FILE__ + (__LINE__).to_s + " FOUND => #{_c.class.to_s} " + _c.name if _c
      _c
    end

    # Any one of hose subtasks could itself be a huge composite with many
    # of its own sub-subtasks.
    def total_number_basic_tasks
      total=0
      @sub_tasks.each { |task| total += task.total_number_basic_tasks }
      total
    end

  end

end