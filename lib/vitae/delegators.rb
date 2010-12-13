module Vitae::Delegators
  
  def class_delegate *args
    target = args.pop[:to] rescue raise(ArgumentError, "Delegation needs a target. Supply an options hash with a :to key as the last argument (e.g. delegate :hello, :to => :greeter).")
    actions = args
    metaclass = (class << self; self; end)
    
    actions.each do |action|
      metaclass.send(:define_method, action) do |*args|
        send(target).send(action, *args)
      end
    end
  end
  
  def delegate *args
    target = args.pop[:to] rescue raise(ArgumentError, "Delegation needs a target. Supply an options hash with a :to key as the last argument (e.g. delegate :hello, :to => :greeter).")
    actions = args
    
    actions.each do |action|
      define_method action do |*args|
        send(target).send(action, *args)
      end
    end
  end
  
end