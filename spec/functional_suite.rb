class FunctionalSuite
  def run(framework_name)
    dir = File.dirname(__FILE__)
    Dir["#{dir}/functional/#{framework_name}/**/*_spec.rb"].each do |file|
      require file
    end
  end
end

["jasmine", "screw-unit"].each do |framework_name|
  pid = fork do
    FunctionalSuite.new.run(framework_name)
  end
  Process.wait(pid)
  $?.success? || raise("#{framework_name} suite failed")
end
