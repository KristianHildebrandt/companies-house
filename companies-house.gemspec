# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{companies-house}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rob McKinnon"]
  s.date = %q{2011-04-11}
  s.description = %q{Ruby API to UK Companies House XML Gateway.
}
  s.email = ["rob ~@nospam@~ rubyforge.org"]
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README"]
  s.files = ["CHANGELOG", "companies-house.yml.example", "init.rb", "lib/companies_house/company_details.haml", "lib/companies_house/exception.rb", "lib/companies_house/name_search.haml", "lib/companies_house/number_search.haml", "lib/companies_house/request.haml", "lib/companies_house/request.rb", "lib/companies_house.rb", "LICENSE", "Manifest", "Rakefile", "README", "README.rdoc", "spec/lib/companies_house/request_spec.rb", "spec/lib/companies_house_spec.rb", "companies-house.gemspec"]
  s.homepage = %q{}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Companies-house", "--main", "README", "--inline-source"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{companies-house}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Ruby API to UK Companies House XML Gateway.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_runtime_dependency(%q<haml>, [">= 2.0.9"])
      s.add_runtime_dependency(%q<morph>, [">= 0.3.2"])
    else
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<haml>, [">= 2.0.9"])
      s.add_dependency(%q<morph>, [">= 0.3.2"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<haml>, [">= 2.0.9"])
    s.add_dependency(%q<morph>, [">= 0.3.2"])
  end
end
