module SpecExampleMetaHelper
  def nested_description(*words)
    words.compact.join(', ')
  end
end
