Gem::Specification.new do |spec|
	spec.name          = "thinkspace"
	spec.version       = "2.5.0"
	spec.authors       = ["Heiswayi Nrird"]
	spec.email         = ["heiswayi@nrird.xyz"]

	spec.summary       = "A minimalist Jekyll theme"
	spec.homepage      = "https://github.com/heiswayi/thinkspace"
	spec.license       = "MIT"

	spec.metadata["plugin_type"] = "theme"

	spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|(LICENSE|README)((\.(txt|md|markdown)|$)))!i) }

	spec.add_runtime_dependency "jekyll", "~> 4.1.1"
	spec.add_runtime_dependency "jekyll-sitemap", "~> 1.4.0"
	spec.add_runtime_dependency "jekyll-paginate", "~> 1.1.0"
	spec.add_runtime_dependency "jekyll-feed", "~> 0.15.0"
	spec.add_development_dependency "bourbon", "~> 7.0.0"
	spec.add_development_dependency "bundler", "~> 2.1.4"
	spec.add_development_dependency "rake", "~> 13.0.1"
	spec.add_development_dependency "html-proofer", "~> 3.15.3"
end
