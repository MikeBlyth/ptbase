class ToHaml
  def initialize(path)
    @path = path
  end

  def convert!
    Dir["#{@path}/**/*.rhtml"].each do |file|
      `html2haml -rx #{file} #{file.gsub(/\.rhtml$/, '.haml')}`
    end
  end
end

path = File.join(File.dirname(__FILE__), 'app', 'views')
ToHaml.new(path).convert!
