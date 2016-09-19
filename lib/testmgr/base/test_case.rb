
# TestCase consists of 0 or more assertions.

module Testmgr

  class TestCase < AbstractTest
    attr_accessor :test_id, :id
    attr_accessor :parent
    attr_accessor :description
    attr_accessor :assertions
    attr_accessor :metrics

    def initialize(_id, desc=nil)
      @test_id=_id
      @description=desc

      @assertions=[]
      @metrics={:passed => 0, :failed => 0, :skipped => 0, :total => 0 }

      super(@test_id)
    end

    def getResult()
      @metrics[:total] > 0 && @metrics[:passed] > 0 && @metrics[:failed]==0
    end

    def getMetrics()
      @metrics
    end

    def add(rc, desc)

      puts __FILE__ + (__LINE__).to_s + " TestCase.add(#{rc}, #{desc})" if Testmgr::TestReport.instance.verbose
      @assertions << { :rc => rc, :description => desc, :time => Time.now }

      if rc.nil?
        @metrics[:skipped]+=1
      elsif rc
        @metrics[:passed]+=1
      else
        @metrics[:failed]+=1
      end

      @metrics[:total]+=1
    end

    def set_parent(parent)
   #   puts __FILE__ + (__LINE__).to_s + " TestComponent::set_parent"
      @parent=parent
    end

    def get_name
      @test_id
    end

    def set_id(id)
      @id=id
      self
    end

    def set_name(name)
      @test_id=name
      self
    end



    def get_time_required
      2.5
    end

    def total_number_basic_tasks
      3
    end

    def child(name)
     # puts __FILE__ + (__LINE__).to_s + " child(#{name}) matches #{@test_id} ??"
      if name == @test_id
     #   puts __FILE__ + (__LINE__).to_s + "Matched #{name} (#{@test_id})"
        return self
      end

  #    puts __FILE__ + (__LINE__).to_s + " No match #{name} (#{@test_id})"
      nil
    end

    def calcResult()

      if @assertions.length < 1
        return nil
      end

      rc=true
      @assertions.each do |a|
        rc = rc && a[:rc]
      end

      rc
    end

    def totalAssertions()
      @assertions.length
    end

    def failed?
      !passed?
    end

    def passed?
      _rc=calcResult()
      !_rc.nil? && _rc
    end

    def print
      s="[requirement - #{parent.name}]:#{@test_id} - #{@description.to_s} : #{@metrics[:passed]}/#{@metrics[:total]} passed: #{calcResult().to_s}"

      if @id
        s += ":#{@id}"
      end

      i=0
      @assertions.each do |a|
        s += "\n  #{i}. " + a[:description].to_s + " : " + a[:rc].to_s
        i+=1
      end

      puts s
      s
    end


    def junitReport(className, doc)
      tapPrint(className, doc)
    end

    # JUNIT
    def tapPrint(className, doc, formatType='JUNIT')

    #  s="[requirement - #{parent.name}]:#{@test_id} - #{@description.to_s} : #{@metrics[:passed]}/#{@metrics[:total]} passed: #{calcResult().to_s}"
    #  if @id
    #    s += ":#{@id}"
    #  end

      i=0
      @assertions.each do |a|
    #   s += "\n  #{i}. " + a[:description].to_s + " : " + a[:rc].to_s

        ts = Nokogiri::XML::Node.new('testcase', doc)
        ts.set_attribute('classname', "#{className}.#{@test_id}")
        ts.set_attribute('name', a[:description])
        ts.set_attribute('time', a[:time])

        if a[:rc].nil?
          skipped=Nokogiri::XML::Node.new('skipped', ts)
          ts.add_child(skipped)
        elsif !a[:rc]
          failed=Nokogiri::XML::Node.new('failure', ts)
          failed.set_attribute('message', "test failure")
          failed.content="Assertion failed"
          ts.add_child(failed)
        elsif a[:rc]
          # Passed
        else
          raise "UNKNOWN_CLASS_Type: #{a}"
        end

        doc.root.add_child(ts)
        i+=1
      end

    end

  end


end