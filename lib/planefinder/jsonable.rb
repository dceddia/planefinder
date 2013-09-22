# Handily stolen from Stack Overflow (david4dev): http://stackoverflow.com/questions/4464050/ruby-objects-and-json-serialization-without-rails
module JSONable
  def to_json(arg=nil)
    puts arg
    hash = {}
    self.instance_variables.each do |var|
      hash[var.to_s.gsub(/^@/, '')] = self.instance_variable_get var
    end
    hash.to_json
  end
end
