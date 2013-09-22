# Handily stolen from Stack Overflow (david4dev): http://stackoverflow.com/questions/4464050/ruby-objects-and-json-serialization-without-rails
module JSONable
  def to_json(arg)
    puts arg
    hash = {}
    self.instance_variables.each do |var|
      hash[var] = self.instance_variable_get var
    end
    hash.to_json
  end
  def from_json! string
    JSON.load(string).each do |var, val|
      self.instance_variable_set var, val
    end
  end
end
