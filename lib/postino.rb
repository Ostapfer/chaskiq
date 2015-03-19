require "postino/engine"
require "haml"
require "simple_form"
require "kaminari"
require "postino/engine"

module Postino
  autoload :VERSION, "postino/version"
  autoload :Config, "postino/config"
  autoload :CsvImporter, "postino/csv_importer"
  autoload :LinkRenamer, "postino/link_renamer"
end
