# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rails_datamapper}
  s.version = "0.10.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tom Malone"]
  s.date = %q{2009-09-08}
  s.description = %q{Rails Plugin for datamapper}
  s.email = ["tomjmalone [a] gmail [d] com"]
  s.extra_rdoc_files = ["README.rdoc", "LICENSE", "TODO", "History.rdoc"]
  s.files = ["History.rdoc", "LICENSE", "Manifest.txt", "README.rdoc", "Rakefile", "TODO", "datamapper.rake", "generators/dm_install/dm_install_generator.rb", "generators/dm_install/templates/datamapper.rake", "generators/dm_migration/dm_migration_generator.rb", "generators/dm_migration/templates/migration.rb", "generators/dm_model/dm_model_generator.rb", "generators/dm_model/templates/model.rb", "generators/dm_model/templates/unit_test.rb", "generators/rspec_dm_model/rspec_dm_model_generator.rb", "generators/rspec_dm_model/templates/model_spec.rb", "lib/rails_datamapper.rb", "lib/rails_datamapper/session_store.rb", "lib/rails_datamapper/version.rb", "tasks/install.rb"]
  s.homepage = %q{http://github.com/datamapper/dm-more/tree/master/rails_datamapper}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{datamapper}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Rails Plugin for datamapper}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, ["= 0.10.0"])
    else
      s.add_dependency(%q<dm-core>, ["= 0.10.0"])
    end
  else
    s.add_dependency(%q<dm-core>, ["= 0.10.0"])
  end
end
