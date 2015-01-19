#!/usr/bin/env ruby

ignore(%w{doc log pkg tmp web work .reap .yardoc})

# Testing

desc 'ruby specs for both rdoc and yard'
task 'spec' do
  spec_run('rdoc')
  spec_run('yard')
end

desc 'run spec for rdoc'
task 'spec-rdoc' do
  spec_run('rdoc')
end

desc 'run specs for yard'
task 'spec-yard' do
  spec_run('yard')
end

def spec_run(parser='rdoc')
  case parser
  when 'rdoc'
    system "parser=#{parser} qed -Ilib spec/*.rdoc spec/08_rdoc/*.rdoc"
  when 'yard'
    system "parser=#{parser} qed -Ilib spec/*.rdoc spec/09_yard/*.rdoc"
  end
end

#

desc "package gem"
task :package do
  sh %{RUBYOPT="-roll -rubygems" detroit package}
end

desc "install gem"
task :install => :package do
  sh %{sudo gem install --no-ri pkg/shomen-0.1.0.gem}
end


