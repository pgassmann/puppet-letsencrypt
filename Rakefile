require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]

# use librarian-puppet to manage fixtures instead of .fixtures.yml
# offers more possibilities like explicit version management, forge downloads,...
task :librarian_spec_prep do
  sh "librarian-puppet install --path=spec/fixtures/modules/"
  pwd = Dir.pwd.strip
  unless File.directory?("#{pwd}/spec/fixtures/modules/letsencrypt")
    # workaround for windows as symlinks are not supported with 'ln -s' in git-bash
    if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
      begin
        sh "cmd /c \"mklink /d #{pwd}\\spec\\fixtures\\modules\\letsencrypt #{pwd}\""
      rescue Exception => e
        puts '-----------------------------------------'
        puts 'Git Bash must be started as Administrator'
        puts '-----------------------------------------'
        raise e
      end
    else
      sh "ln -s #{pwd} #{pwd}/spec/fixtures/modules/letsencrypt"
    end
  end
end

# Windows rake spec task for git bash
# default spec task fails because of unsupported symlinks on windows
task :spec_win do
  sh "rspec --pattern spec/\{classes,defines,unit,functions,hosts,integration\}/\*\*/\*_spec.rb --color"
end

task :spec_clean_win do
  pwd = Dir.pwd.strip
  sh "cmd /c \"rmdir /q #{pwd}\\spec\\fixtures\\modules\\letsencrypt\""
end

task :spec_prep => :librarian_spec_prep

desc "Validate manifests, templates, and ruby files"
task :validate do
  Dir['manifests/**/*.pp'].each do |manifest|
    sh "puppet parser validate --noop #{manifest}"
  end
  Dir['spec/**/*.rb','lib/**/*.rb'].each do |ruby_file|
    sh "ruby -c #{ruby_file}" unless ruby_file =~ /spec\/fixtures/
  end
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
end

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  task :default => [:spec_prep, :spec_win, :spec_clean, :spec_clean_win, :lint]
else
  task :default => [:spec, :validate]
end
