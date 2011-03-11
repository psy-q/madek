# -*- encoding : utf-8 -*-
require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module MAdeK
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    config.cache_store = :mem_cache_store, {:namespace => "MAdeK_#{Rails.env}_#{Rails.root}"}

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Bern'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = %w(jquery.min jquery-ui.min rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
  end
end

# Config files here.
METADATA_CONFIG_DIR = "#{Rails.root}/config/definitions/metadata"

# We have a variety of different storage location constants defined here because we *might* at some point want to optimise
# our storage (e.g. placing temp files on a fast filesystem, and permanent files in a 'slower' filesystem).
TEMP_STORAGE_DIR    = "#{Rails.root}/tmp/uploads" # TODO this constant is currently badly named.
ZIP_STORAGE_DIR     = "#{Rails.root}/tmp/zipfiles" # NB This should be regularly cleaned
DOWNLOAD_STORAGE_DIR    = "#{Rails.root}/tmp/downloads" # this all needs rationalising, which will happen soon.

# NB This is sharded. Likely to be used infrequently.
FILE_STORAGE_DIR    = "#{Rails.root}/db/media_files/#{Rails.env}/attachments"
# NB This is sharded. A good candidate for a fast filesystem, since thumbnails will be used regularly.
THUMBNAIL_STORAGE_DIR = "#{Rails.root}/db/media_files/#{Rails.env}/attachments"

# symbolic links, to ultimately break your installation :-/
# $ sudo ln -s /usr/bin/exiftool /usr/local/bin/exiftool
# $ sudo ln -s /usr/bin/lib /usr/local/bin/lib
EXIFTOOL_CONFIG = "#{METADATA_CONFIG_DIR}/ExifTool_config.pl"
EXIFTOOL_PATH = "/usr/local/bin/exiftool -config #{EXIFTOOL_CONFIG}"
# Ideally, this would work under script/server AND passenger, but it doesn't.
# Under passenger, it has no idea. Maybe substitute as part of the Capistrano deploy?
# EXIFTOOL_PATH = `/usr/bin/which exiftool`.gsub(/\n/,"") 

# yes, this could be optimised..
tmp_ext = `exiftool -listf`.downcase.split("\n") # a list of file extensions that exiftool knows about. If it's here, its a good chance it's file we can understand
tmp_ext.shift # get rid of the "recognized file extensions:"
KNOWN_EXTENSIONS = tmp_ext.join.split # now we have an array of individual extensions..
tmp_ext = nil

DOT_PATH = "/usr/local/bin/dot"
FILE_UTIL_PATH = "/usr/bin/file " + (`uname -s`.include?("Darwin") ? "-Ib" : "-ib")

THUMBNAILS = { :x_large => '1024x768>', :large => '620x500>', :medium => '300x300>', :small_125 => '125x125>', :small => '100x100>', :x_small => '50x50>' }
PER_PAGE = [18,54,108]

DEFAULT_ACTION_PERMISSIONS = {  :view => false, # read
                                :edit => false #, # update
                                # TODO :create => true,
                                # TODO :delete => false
                              }

LANGUAGES = [:de_CH, :en_GB]
DEFAULT_LANGUAGE = :de_CH

VIDEO_ENCODING_BASE_URL = "http://test:MAdeK@test.madek.zhdk.ch"

RELEASE_VERSION = "0.2.3.1"
